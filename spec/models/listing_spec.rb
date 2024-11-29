require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:user) { User.create(name: "User", email: "email@user.com", password: "123456789") }

  context "url" do
    it "should be valid when is airbnb" do
      listing = Listing.new users: [ user ], name: "My Listing", url: "https://www.airbnb.com/h/roofdeckhottub"

      expect(listing).to be_valid
    end

    it "should be valid when is airbnb with params" do
      listing = Listing.new users: [ user ], name: "My Listing", url: "https://www.airbnb.com.br/rooms/52596108?_set_bev_on_new_domain=1732795680_EANWJlOGFkZjMyMj&source_impression_id=p3_1732903736_P3nB1KEwIkgbTeuS"

      expect(listing).to be_valid
    end

    it "should be invalid when is not airbnb" do
      listing = Listing.new users: [ user ], name: "My Listing", url: "https://mail.google.com/mail/"

      expect(listing).to_not be_valid
    end

    it "should be invalid when nil" do
      listing = Listing.new users: [ user ], name: "My Listing", url: nil

      expect(listing).to_not be_valid
    end

    it "should be invalid when blank" do
      listing = Listing.new users: [ user ], name: "My Listing", url: ""

      expect(listing).to_not be_valid
    end
  end
end
