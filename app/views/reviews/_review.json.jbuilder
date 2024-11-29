json.extract! review, :id, :author, :rating, :text, :date, :listing_id, :created_at, :updated_at
json.url review_url(review, format: :json)
