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

ActiveRecord::Schema.define(version: 2022_11_26_073136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.string "room_type"
    t.bigint "hotel_id"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hotel_id"], name: "index_amenities_on_hotel_id"
  end

  create_table "hotel_raw_data", force: :cascade do |t|
    t.string "source"
    t.string "identifier"
    t.integer "destination_id"
    t.string "name"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "address"
    t.string "postal_code"
    t.string "city"
    t.string "country"
    t.string "description"
    t.jsonb "images"
    t.jsonb "amenities"
    t.string "booking_conditions", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_hotel_raw_data_on_identifier"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "destination_id", null: false
    t.string "name"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "address"
    t.string "city"
    t.string "country"
    t.text "description"
    t.jsonb "amenities"
    t.jsonb "images"
    t.string "booking_conditions", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_generated_at"
    t.index ["destination_id"], name: "index_hotels_on_destination_id"
    t.index ["identifier"], name: "index_hotels_on_identifier", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.string "room_type"
    t.bigint "hotel_id"
    t.string "link"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hotel_id"], name: "index_images_on_hotel_id"
  end

end
