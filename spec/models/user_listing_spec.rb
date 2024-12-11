require 'rails_helper'

RSpec.describe UserListing, type: :model do
  let(:user) { User.create(name: 'User', email: 'email@user.com', password: '123456789') }
  let(:listing) { Listing.create(name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314') }

  context 'url' do
    it 'should be valid when is airbnb' do
      user_listing = UserListing.new user: user, listing: listing, pending: true, url: 'https://www.airbnb.com/h/roofdeckhottub'

      expect(user_listing).to be_valid
    end

    it 'should be valid when is airbnb with params' do
      user_listing = UserListing.new user: user, listing: listing, pending: true,
                                     url: 'https://www.airbnb.com.br/rooms/52596108?_set_bev_on_new_domain=1732795680_EANWJlOGFkZjMyMj&source_impression_id=p3_1732903736_P3nB1KEwIkgbTeuS'

      expect(user_listing).to be_valid
    end

    it 'should be invalid when is not airbnb' do
      user_listing = UserListing.new user: user, listing: listing, pending: true, url: 'https://mail.google.com/mail/'

      expect(user_listing).to_not be_valid
    end

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
