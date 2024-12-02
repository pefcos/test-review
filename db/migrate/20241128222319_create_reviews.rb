class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.string :author, null: false
      t.string :text, null: false
      t.date :date, null: false
      t.string :airbnb_review_id, null: false
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reviews, :airbnb_review_id, unique: true
  end
end
