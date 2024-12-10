require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:review1) do
    Review.create(listing: listing, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                  airbnb_review_id: '1297970922053023032')
  end
  let(:review2) do
    Review.create(listing: listing, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                  airbnb_review_id: '1297970922053023032')
  end

  context 'url' do
    it 'should be valid when is airbnb' do
      listing = Listing.new name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314'

      expect(listing).to be_valid
    end

    it 'should be valid when is airbnb with params' do
      listing = Listing.new name: 'Listing', url: 'https://www.airbnb.com.br/rooms/52596108?_set_bev_on_new_domain=1732795680_EANWJlOGFkZjMyMj&source_impression_id=p3_1732903736_P3nB1KEwIkgbTeuS',
                            airbnb_id: '52596108'

      expect(listing).to be_valid
    end

    it 'should be invalid when is not airbnb' do
      listing = Listing.new name: 'Listing', url: 'https://mail.google.com/mail/', airbnb_id: '1234141'

      expect(listing).to_not be_valid
    end

    it 'should be invalid when nil' do
      listing = Listing.new name: 'Listing', url: nil, airbnb_id: '1234141'

      expect(listing).to_not be_valid
    end

    it 'should be invalid when blank' do
      listing = Listing.new name: 'Listing', url: '', airbnb_id: '1234141'

      expect(listing).to_not be_valid
    end
  end

  context 'review_word_cloud' do
    it 'should not count overused words' do
      listing = Listing.create name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314'
      Review.create listing: listing, author: 'Author', text: 'i the a an and this that was is',
                    date: Date.new(2024, 10, 2), airbnb_review_id: '1297970922053023032'

      expect(listing.review_word_cloud).to eq([])
    end

    it 'should count words correctly' do
      listing = Listing.create name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314'
      Review.create listing: listing, author: 'Author', text: 'the word word sky word', date: Date.new(2024, 10, 2),
                    airbnb_review_id: '1297970922053023032'

      expect(listing.review_word_cloud).to eq([['word', 3], ['sky', 1]])
    end

    it 'should be empty when reviews are textless' do
      listing = Listing.create name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314'
      Review.create listing: listing, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                    airbnb_review_id: '1297970922053023032'

      expect(listing.review_word_cloud).to eq([])
    end
  end
end
