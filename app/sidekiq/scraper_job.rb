class ScraperJob
  include Sidekiq::Job

  sidekiq_options retry: 3
  sidekiq_options queue: 'default'

  def perform(url, user_listing_id)
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for(:firefox, options: options)

    ScraperService.new(url, driver, user_listing_id).call

    driver.quit
  end
end
