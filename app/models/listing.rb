class Listing < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :user_listings
  has_many :users, through: :users_listings

  validates :url, presence: true
  validates :url, format: { with: %r{\Ahttps://www\.airbnb\.com}, message: 'is not a valid Airbnb URL.' }

  def review_word_cloud
    all_frequencies = {}
    reviews.each do |rev|
      rev.count_word_frequencies.each do |w, c|
        all_frequencies[w] = 0 unless all_frequencies.include? w
        all_frequencies[w] += c
      end
    end
    all_frequencies.to_a
  end
end
