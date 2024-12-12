class CreateUserListings < ActiveRecord::Migration[7.2]
  def change
    create_table :user_listings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :listing, foreign_key: true
      t.boolean :pending
      t.string :url

      t.timestamps
    end
  end
end
