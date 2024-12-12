class ScraperService
  def initialize(url, driver, user_listing_id)
    @driver = driver
    @user_listing = UserListing.find(user_listing_id)

    @driver.navigate.to url
    sleep 4
  end

  def call
    airbnb_listing_id = @driver.current_url.match(%r{/\d+\?})[0].gsub(/\d+/).first

    listing = Listing.find_or_create_by(airbnb_id: airbnb_listing_id) do |li|
      li.name = @driver.find_element(css: "div[data-section-id='TITLE_DEFAULT'] h1").text
      li.airbnb_id = @driver.current_url.match(%r{/\d+\?})[0].gsub(/\d+/).first
      li.url = "https://www.airbnb.com/rooms/#{li.airbnb_id}"
    end

    button = @driver.find_elements(css: "button[data-testid='pdp-show-all-reviews-button']").first
    if button.present?
      scrape_dialog_reviews listing, button
    else
      scrape_page_reviews listing
    end

    generate_word_cloud listing

    @user_listing.update!(listing: listing, pending: false) if @user_listing.present?
  end

  private

  def scrape_dialog_reviews(listing, button)
    open_and_scroll_dialog button

    existing_review_ids = listing.reviews.collect(&:airbnb_review_id)

    reviews = @driver.find_elements(css: "div[data-testid='pdp-reviews-modal-scrollable-panel'] div[data-review-id]")

    reviews.each do |review|
      review_id = review.attribute('data-review-id')
      next if existing_review_ids.include?(review_id)

      author = review.find_element(css: 'div section div div h2').text
      date = Chronic.parse(review.find_element(css: 'div div').text.split("\n")[5]).to_date
      review_text = review.find_element(css: 'div div div span span').text

      listing.reviews.create author: author, text: review_text, airbnb_review_id: review_id, date: date
    end
  end

  def open_and_scroll_dialog(button)
    # Calculate number of times to scroll (reviews/10)
    scrolls = button.attribute('innerHTML').match(/\d{1,3}(,\d{3})*/)[0].gsub(',', '').to_i / 10
    @driver.execute_script('arguments[0].click();', button)
    sleep 2

    # Scrolling to load reviews. Approx. 10 reviews are loaded every scroll.
    scrolls.times do
      @driver.execute_script("document.querySelector(\"div[role='dialog'] div:has(div[tabindex='0'])\").scrollBy(0,5000);")

      sleep 1
    end
  end

  def scrape_page_reviews(listing)
    reviews = @driver.find_elements(css: "section div div div[role='list'] div[role='listitem']")

    existing_review_ids = listing.reviews.collect(&:airbnb_review_id)

    reviews.each do |review|
      review_id = review.find_element(css: "div div div div div[id^='review']").attribute('id').match(/\d+/).to_s
      next if existing_review_ids.include?(review_id)

      author = review.find_element(css: 'div div div div div h3').attribute('innerHTML')
      date = Chronic.parse(ActionController::Base.helpers.strip_tags(review.find_element(css: 'div div div.s78n3tv')
                    .attribute('innerHTML')).match(/·.+·/)).to_date
      review_text = review.find_element(css: 'div div div div span span').attribute('innerHTML')

      listing.reviews.create author: author, text: review_text, airbnb_review_id: review_id, date: date
    end
  end

  def generate_word_cloud(listing)
    # Generate and save word cloud.
    image_blob = MagicCloud::Cloud.new(listing.review_word_cloud, rotate: :square, font_family: 'Arial').draw(800, 500)
    image_blob.format = 'png'
    listing.word_cloud_image.attach(io: StringIO.new(image_blob.to_blob), filename: "listing_#{listing.id}_cloud.png",
                                    content_type: 'image/png')
  end
end
