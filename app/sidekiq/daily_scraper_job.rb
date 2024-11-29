class ScraperJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(url)
    logger.info "Started daily scraping"

    Listings.all.each do |listing|
      ScraperJob.perform_async(listing)
    end

    # Extract data (customize this based on your scraping requirements)
    parsed_page.css("h1, h2, h3").each do |heading|
      logger.info "Found heading: #{heading.text.strip}"
    end

    # Save or process the extracted data
    logger.info "Scraping completed for URL: #{url}"
  end
end
