require 'rails_helper'

RSpec.describe UserListing, type: :model do
  let(:user) { User.create(name: 'User', email: 'email@user.com', password: '123456789') }
  let(:listing) { Listing.create(name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314') }

  context 'url' do
    it 'should be invalid without user' do
      user_listing = UserListing.new user: nil, listing: listing, pending: true, url: 'https://www.airbnb.com/h/roofdeckhottub'

      expect(user_listing).to_not be_valid
    end

    it 'should be valid without listing' do
      user_listing = UserListing.new user: user, listing: nil, pending: true, url: 'https://www.airbnb.com/h/roofdeckhottub'

      expect(user_listing).to be_valid
    end
  end
end
