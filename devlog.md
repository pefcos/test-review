# Devlog

This is a file containing text information about the application development and thought behind some of the design process.

This is mainly meant to explain and justify some of the choices made.

## The Database

The database used is SQLite. As for the models and subsequent database tables, we have 4 models, each with its own role.

- **User**: The gem Devise was used in order to set up user and authentication in a fast way. A name field was added to the devise model.
- **UserListing**: This is a model mainly used in order to track what listings the user requested to track and which date they were added. Multiple users may have different UserListings to a same listing.
- **Listing**: The true representation of an Airbnb listing, only one can exist for each Airbnb listing, and it may be accessed by multiple UserListings. This is the true container for reviews and Listing data, such as name and the Airbnb platform ID.
- **Review**: This is the entity that represents a review in Airbnb. It belongs to a single listing.

*Side note: This model division took some experimenting and thinking to get to. I found it to be the most consistent way to keep track of data and avoid re-scraping data which we already own, since each Airbnb listing has only a single "true" representation, which all the UserListings can pull from.*

## The Routes/Controllers

Since the whole application revolves around the user's listings, only two controllers and sets of routes were needed: Users and UserListings.

Upon authentication, pretty much all interaction the user can have with the app is through their UserListings, and the main routes of the UserListingsController are:

- **index**: Which lists the user's UserListings. To keep things simpler, I decided to include the form to create new listings in the index view, so that it requires one less click (which would lead to the "new" route) in order for the user to add a new listing to track.
- **create**: Which adds a UserListing.
- **show**: Where the bar chart and the word cloud is located. These are pulled from the associated Listing and its reviews.
- **destroy**: Where the user can stop tracking a listing.

## The Views

In order to create a good-looking UI that was fast to code, I've used the Bootstrap front-end library.

The word-cloud and bar-charts are generated in the back-end and sent to the front-end.

## The Testing

I've used RSpec to test my models and their validations. This allows for automated testing which ensures that nothing breaks whenever a change is made to a model.

## The Scraping

Okay, I think this might be the most difficult part of the project to get right, there are a lot of moving parts and messing up any of them could lead to massive slow-downs and/or data inconsistencies.

### Technologies

To handle the scraping, I've used Selenium along with the Firefox Browser and geckodriver to connect to Airbnb. These were chosen because they were the easiest to set up.

The scraping itself is done through a Sidekiq job and the job requires Redis to run, as Redis is the queue manager behind Sidekiq.

### The Method

In order to get most of the elements, I used CSS selectors. This allows me to get information from the HTML pages. I've avoided using classes, as the names of the classes seem to be hashed or dynamically assigned upon asset compilation. This led me to using other forms of reference, like data attributes and relative position to parent/child elements with those attributes.

One big hurdle I faced, is the fact that the reviews are loaded dynamically when a component is scrolled, so I had to find a method to scroll it through JS. The strategy adopted to deal with this dynamic loading of reviews is to scroll to the bottom to load all reviews, and once all of them are loaded, properly scrape the elements and create the Review models if they don't yet exist for the given review (this check is made through the review's id from the Airbnb platform).

### The Responsiveness Issue

Once a user enters an URL to be tracked, the scraping process my take a long time. Imagine a listing with over 1,000 reviews, that would certainly take a long time to process. I needed a way to let the user know the listing is being processed or is enqueued to be processed.

This was achieved through the UserListing model, which received a "pending" attribute, which is set to true whenever the UserListing is created, and upon job completion, is set to false by the ScraperJob. 

## Features

### The Chart

Implemented using Chart.js, which renders the data in a nice graph in the front-end
