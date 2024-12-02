class CreateUserListings < ActiveRecord::Migration[7.2]
  def change
    create_table :user_listings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, foreign_key: true
      t.boolean :pending
      t.string :url

      t.timestamps
    end

    add_index :user_listings, %i[user_id listing_id], unique: true
    add_index :user_listings, %i[listing_id user_id], unique: true
  end
end
