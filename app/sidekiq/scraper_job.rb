class ScraperJob
  include Sidekiq::Job

  sidekiq_options retry: 2
  sidekiq_options queue: 'default'

  def perform(url, user_listing_id = nil)
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for(:firefox, options: options)

    driver.navigate.to url
    sleep 4

    airbnb_listing_id = driver.current_url.match(%r{/\d+\?})[0].gsub(/\d+/).first
    title = driver.find_element(css: "div[data-section-id='TITLE_DEFAULT'] h1").text

    # Create or get listing
    listing = Listing.find_or_create_by(airbnb_id: airbnb_listing_id) do |li|
      li.name = title
      li.url = "https://www.airbnb.com/rooms/#{airbnb_listing_id}"
    end

    existing_review_ids = listing.reviews.collect(&:airbnb_review_id)

    button = driver.find_elements(css: "button[data-testid='pdp-show-all-reviews-button']").first
    if button.present?
      # > 6 reviews, needs to click button to gather all
      # Get number of reviews, accounting for possible "," in the number. Used for review scrolling.
      scrolls = button.attribute("innerHTML").match(/\d{1,3}(,\d{3})*/)[0].gsub(',', '').to_i / 10
      driver.execute_script('arguments[0].click();', button)
      sleep 2

      # Scrolling to load reviews. Approx. 10 reviews are loaded every scroll.
      scrolls.times do |si|
        driver.execute_script("document.querySelector(\"div[role='dialog'] div:has(div[tabindex='0'])\").scrollBy(0,5000);")

        sleep 1
      end

      reviews = driver.find_elements(css: "div[data-testid='pdp-reviews-modal-scrollable-panel'] div[data-review-id]")
      reviews.each do |review|
        review_id = review.attribute('data-review-id')
        next if existing_review_ids.include?(review_id)

        author = review.find_element(css: 'div section div div h2').text
        date = Chronic.parse(review.find_element(css: 'div div').text.split("\n")[5]).to_date # TODO: Check BETWEEN TWO div[aria-hidden='true']
        review_text = review.find_element(css: 'div div div span span').text

        listing.reviews.create author: author, text: review_text, airbnb_review_id: review_id, date: date
      end
    else
      # <= 6 reviews, all reviews are already on page, no need for modal dialog.
      # REVIEW: div[role='list'] div[role='listitem'] 
      # AUTHOR: <REVIEW> div div div div div h3
      # TEXT: div div div div span span
      # DATE: div div div (innertext) - IN BETWEEN TWO div[aria-hidden='true']

      reviews = driver.find_elements(css: "section div div div[role='list'] div[role='listitem']")
      reviews.each do |review|
        review_id = review.find_element(css: "div div div div div[id^='review']").attribute('id').match(/\d+/).to_s
        next if existing_review_ids.include?(review_id)

        author = review.find_element(css: 'div div div div div h3').attribute("innerHTML")
        date = Chronic.parse(review.find_element(css: "div div div.s78n3tv").attribute("innerHTML").match(/\d (week|day)s? ago/)).to_date # TODO: Check BETWEEN TWO div[aria-hidden='true']
        review_text = review.find_element(css: 'div div div div span span').attribute("innerHTML")

        listing.reviews.create author: author, text: review_text, airbnb_review_id: review_id, date: date
      end
    end

    # Generate and save word cloud.
    image_blob = MagicCloud::Cloud.new(listing.review_word_cloud, rotate: :square, font_family: "Arial").draw(800, 500)
    image_blob.format = 'png'
    listing.word_cloud_image.attach(io: StringIO.new(image_blob.to_blob), filename: "listing_#{listing.id}_cloud.png",
                                    content_type: 'image/png')

    driver.quit

    # Save or process the extracted data
    logger.info("Scraping completed for listing #{listing.airbnb_id}")

    UserListing.find(user_listing_id).update!(listing: listing, pending: false) if user_listing_id.present?
  end
end
