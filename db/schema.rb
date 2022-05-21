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

ActiveRecord::Schema[7.0].define(version: 2022_05_21_141131) do
  create_table "carriers", force: :cascade do |t|
    t.string "corporate_name"
    t.string "brand_name"
    t.string "registration_number"
    t.string "full_address"
    t.string "city"
    t.string "state"
    t.string "email_domain"
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer "cubic_meter_min"
    t.integer "cubic_meter_max"
    t.integer "minimum_weight"
    t.integer "maximum_weight"
    t.integer "km_price"
    t.integer "carrier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_prices_on_carrier_id"
  end

  create_table "terms", force: :cascade do |t|
    t.integer "minimum_distance"
    t.integer "maximum_distance"
    t.integer "days"
    t.integer "carrier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_terms_on_carrier_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate"
    t.string "identification"
    t.string "brand"
    t.string "mockup"
    t.integer "year"
    t.string "capacity"
    t.integer "carrier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["carrier_id"], name: "index_vehicles_on_carrier_id"
  end

  add_foreign_key "prices", "carriers"
  add_foreign_key "terms", "carriers"
  add_foreign_key "vehicles", "carriers"
end
