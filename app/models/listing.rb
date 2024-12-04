class Listing < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :user_listings
  has_many :users, through: :users_listings

  validates :url, presence: true
  validates :url, format: { with: %r{\Ahttps://www\.airbnb\.com}, message: 'is not a valid Airbnb URL.' }

  has_one_attached :word_cloud_image

  def review_word_cloud
    fullreviews = ''
    reviews.each do |rev|
      fullreviews += " #{rev.text}"
    end

    fullreviews = fullreviews.gsub(/[^(a-z|A-Z) ]/, '').downcase
    # Decided to remove the uninteresting words. The line below can be commmented if you wish to include them.
    fullreviews = fullreviews.gsub(/\b(i|the|a|an|and|this|that|was|is)\b/, ' ')

    fullreviews = fullreviews.split(' ').each_with_object(Hash.new(0)) do |item, hash|
      hash[item] += 1
    end.to_a

    (fullreviews.sort_by { |k, v| -v })[0..49]
  end
end
