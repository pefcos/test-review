class Review < ApplicationRecord
  self.primary_key = :rating_id

  belongs_to :listing

  validates :author, presence: true
  validates :rating, presence: true
  validates_inclusion_of :rating, in: 1..5
end
