class CreateListings < ActiveRecord::Migration[7.2]
  def change
    create_table :listings do |t|
      t.string :url, null: false
      t.string :name

      t.timestamps
    end
  end
end
