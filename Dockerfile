# Base image
FROM ruby:3.2

# Install required packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    firefox-esr \
    wget \
    redis-server \
    supervisor \
    gsfonts

# Install Geckodriver
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/v0.35.0/geckodriver-v0.35.0-linux64.tar.gz" -O geckodriver.tar.gz && \
    tar -xvzf geckodriver.tar.gz -C /usr/local/bin && \
    rm geckodriver.tar.gz

# Set working directory
WORKDIR /app

# Copy application files
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application files
COPY . .

# Set up Redis and Sidekiq to run with Supervisor
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisor-sidekiq.conf /etc/supervisor/conf.d/sidekiq.conf
COPY supervisor-redis.conf /etc/supervisor/conf.d/redis.conf

# Precompile assets (if necessary)
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Expose necessary ports
EXPOSE 3000 6379

# Start Supervisor to manage services
CMD ["supervisord", "-n"]
