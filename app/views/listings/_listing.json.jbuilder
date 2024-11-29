json.extract! listing, :id, :url, :user_id, :created_at, :updated_at
json.url listing_url(listing, format: :json)
