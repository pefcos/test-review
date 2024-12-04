class DailyScraperJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform
    logger.info 'Started daily scraping'

    Listings.all.each do |listing|
      ScraperJob.perform_async(listing.url, nil)
    end

    # Save or process the extracted data
    logger.info 'Daily scraping completed'
  end
end
