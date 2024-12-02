# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_29_222144) do
  create_table "listings", force: :cascade do |t|
    t.string "url", null: false
    t.string "name"
    t.string "airbnb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airbnb_id"], name: "index_listings_on_airbnb_id", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.string "author", null: false
    t.string "text", null: false
    t.date "date", null: false
    t.string "airbnb_review_id", null: false
    t.integer "listing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airbnb_review_id"], name: "index_reviews_on_airbnb_review_id", unique: true
    t.index ["listing_id"], name: "index_reviews_on_listing_id"
  end

  create_table "user_listings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "listing_id"
    t.boolean "pending"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id", "user_id"], name: "index_user_listings_on_listing_id_and_user_id", unique: true
    t.index ["listing_id"], name: "index_user_listings_on_listing_id"
    t.index ["user_id", "listing_id"], name: "index_user_listings_on_user_id_and_listing_id", unique: true
    t.index ["user_id"], name: "index_user_listings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reviews", "listings"
  add_foreign_key "user_listings", "listings"
  add_foreign_key "user_listings", "users"
end
