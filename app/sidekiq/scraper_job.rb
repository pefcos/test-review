class ScraperJob
  include Sidekiq::Job

  sidekiq_options retry: 2

  def perform(url)
    # Fetch the page using HTTParty
    response = HTTParty.get(url, timeout: 10)
    raise "Timeout" if response.timed_out?

    # Handle HTTP errors
    unless response.success?
      logger.error("Failed to fetch URL: #{url} - Status: #{response.code}")
      raise "HTTP Error: #{response.code}"
    end

    # Parse the HTML response with Nokogiri
    parsed_page = Nokogiri::HTML(response.body)

    # "button[data-testid='pdp-show-all-reviews-button']" -> Button to show all reviews.
    # "div[data-testid='pdp-reviews-modal-scrollable-panel']" -> Selector for the reviews panel.
    #   - "data-review-id" -> FIRST MATCH stores review_id for airbnb
    # "div[data-testid='pdp-reviews-modal-scrollable-panel'] div section div div h2" -> FIRST MATCH Author name
    # "div[data-testid='pdp-reviews-modal-scrollable-panel'] div div div span" -> FIRST MATCH Review star count (use .gsub(/\d/).first.to_i to get as number)
    # "div[data-testid='pdp-reviews-modal-scrollable-panel'] div div div span span" -> FIRST MATCH Review text
    #
    # HOW TO GET REVIEWS AFTER SCROLLING?
    #

    # Extract data (customize this based on your scraping requirements)
    parsed_page.css("h1, h2, h3").each do |heading|
      logger.info("Found heading: #{heading.text.strip}")
    end

    # Save or process the extracted data
    logger.info("Scraping completed for URL: #{url}")
  end
end
