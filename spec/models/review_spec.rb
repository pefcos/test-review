require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:listing) { Listing.create(name: 'Listing', url: 'https://www.airbnb.com/h/roofdeckhottub', airbnb_id: '124314') }

  context 'author' do
    it 'should be valid when present' do
      review = Review.new listing: listing, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                          airbnb_review_id: '1297970922053023032'

      expect(review).to be_valid
    end

    it 'should be invalid when nil' do
      review = Review.new listing: listing, author: nil, text: '', date: Date.new(2024, 10, 2),
                          airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end

    it 'should be invalid when blank' do
      review = Review.new listing: listing, author: '', text: '', date: Date.new(2024, 10, 2),
                          airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end
  end

  context 'listing' do
    it 'should be invalid when listing is nil' do
      review = Review.new listing: nil, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                          airbnb_review_id: '1297970922053023032'

      expect(review).to_not be_valid
    end
  end

  context 'airbnb_review_id' do
    it 'should be valid when listing is unique and present' do
      Review.create listing: nil, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                    airbnb_review_id: '1297970922053023032'
      review2 = Review.new listing: nil, author: 'Author', text: '', date: Date.new(2024, 10, 2),
                           airbnb_review_id: '1297970922053023032'

      expect(review2).to_not be_valid
    end
  end
end
