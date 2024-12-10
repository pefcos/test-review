class Review < ApplicationRecord
  validates :author, presence: true

  belongs_to :listing
end
