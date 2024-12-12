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

    it 'should be valid when is foreign language airbnbs' do
      user_listing = UserListing.new user: user, listing: listing, pending: true,
                                     url: 'https://www.airbnb.co.uk/rooms/904427361157995839?adults=2&category_tag=Tag%3A7769&children=0&enable_m3_private_room=true&infants=0&pets=0&photo_id=1762744764&search_mode=flex_destinations_search&check_in=2025-02-03&check_out=2025-02-08&source_impression_id=p3_1733945629_P3bB-cfCnWxmNtDz&previous_page_section_name=1000&federated_search_id=03bbe8a8-50b4-48fd-a442-1b72b8e2ea44&_set_bev_on_new_domain=1733831398_EANjUzYTM1ODAxYj'

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
