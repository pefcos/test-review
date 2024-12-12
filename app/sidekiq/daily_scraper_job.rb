class DailyScraperJob
  include Sidekiq::Job

  sidekiq_options retry: false
  sidekiq_options queue: 'default'

  def perform
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for(:firefox, options: options)

    Listings.all.each do |listing|
      ScraperService.new(listing.url, driver, listing.id).call
    end

    driver.quit
  end
end
