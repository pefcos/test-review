class CreateListings < ActiveRecord::Migration[7.2]
  def change
    create_table :listings do |t|
      t.string :url, null: false
      t.string :name
      t.string :airbnb_id

      t.timestamps
    end

    add_index :listings, :airbnb_id, unique: true
  end
end
