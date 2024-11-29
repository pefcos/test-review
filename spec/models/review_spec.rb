require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { User.create(name: "User", email: "email@user.com", password: "123456789") }
  let(:listing) { Listing.create(users: [ user ], name: "My Listing", url: "https://www.airbnb.com/h/roofdeckhottub") }

  context "author" do
    it "should be valid when present" do
      review = Review.new listing: listing, author: "Author", rating: 3, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to be_valid
    end

    it "should be invalid when nil" do
      review = Review.new listing: listing, author: nil, rating: 3, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end

    it "should be invalid when blank" do
      review = Review.new listing: listing, author: "", rating: 3, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end
  end

  context "rating" do
    it "should be valid when between 1 and 5" do
      review = Review.new listing: listing, author: "Author", rating: 5, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to be_valid
    end

    it "should be invalid when < 1" do
      review = Review.new listing: listing, author: "Author", rating: 0, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end

    it "should be invalid when > 5" do
      review = Review.new listing: listing, author: "Author", rating: 6, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end

    it "should be invalid when nil" do
      review = Review.new listing: listing, author: "Author", rating: nil, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end
  end

  context "listing" do
    it "should be invalid when listing is nil" do
      review = Review.new listing: nil, author: "Author", rating: 3, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end
  end

  # TODO: Add tests
  # context "airbnb_review_id" do
  #   it "should be valid when listing is unique and present" do
  #     review1 = Review.new listing: listing, author: "Author", rating: 3, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'
  #     review2 = Review.new listing: listing, author: "Author", rating: 3, text: "", date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

  #     expect(review).to_not be_valid
  #   end
  # end
end
