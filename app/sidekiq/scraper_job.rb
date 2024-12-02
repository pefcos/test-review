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
    sleep 4

    button = driver.find_element(css: "button[data-testid='pdp-show-all-reviews-button']")
    # Get number of reviews, accounting for possible "," in the number. Used for review scrolling.
    scrolls = button.text.match(/\d{1,3}(,\d{3})*/)[0].gsub(',', '').to_i / 10
    button.click
    sleep 2

    # scrollable_panel = driver.find_element(:css, "div[role='dialog'] div[tabindex='0']").find_element(xpath: './..')
    scrolls.times do |si|
      driver.execute_script("document.querySelector(\"div[role='dialog'] div:has(div[tabindex='0'])\").scrollBy(0,5000);")

      sleep 1
    end

    existing_review_ids = listing.reviews.collect(&:airbnb_review_id)

    reviews = driver.find_elements(css: "div[data-testid='pdp-reviews-modal-scrollable-panel'] div[data-review-id]")
    reviews.each do |review|
      review_id = review.attribute('data-review-id')
      continue if existing_review_ids.include? review_id

      author = review.find_element(css: 'div section div div h2').text
      # rating = review.find_element(css: 'div div div span').text.gsub(/\d/).first.to_i
      review_text = review.find_element(css: 'div div div span span').text

      listing.reviews.create author: author, text: review_text, airbnb_review_id: review_id, date: Date.today
    end

    driver.quit

    # Save or process the extracted data
    logger.info("Scraping completed for listing #{listing.airbnb_id}")

    UserListing.find(user_listing_id).update!(listing: listing, pending: false) if user_listing_id.present?
  end
end
