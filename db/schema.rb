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

ActiveRecord::Schema[7.1].define(version: 2023_11_30_194144) do
  create_table "inns", force: :cascade do |t|
    t.string "brand_name"
    t.string "legal_name"
    t.string "vat_number"
    t.text "phone"
    t.string "email"
    t.string "address"
    t.string "zone"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.text "description"
    t.boolean "pet_friendly"
    t.boolean "wheelchair_accessible"
    t.text "rules"
    t.time "check_in"
    t.time "check_out"
    t.boolean "active"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_opt"
    t.index ["user_id"], name: "index_inns_on_user_id"
    t.index ["vat_number"], name: "index_inns_on_vat_number", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id"
    t.date "start_date"
    t.date "end_date"
    t.integer "guests"
    t.string "code"
    t.integer "status"
    t.integer "total_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.string "payment"
    t.integer "estimate"
    t.integer "nights"
    t.integer "grade"
    t.string "comment"
    t.string "response"
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "size"
    t.integer "max_guests"
    t.float "base_price"
    t.boolean "bathroom"
    t.boolean "balcony"
    t.boolean "air_conditioning"
    t.boolean "tv"
    t.boolean "wardrobe"
    t.boolean "safe"
    t.boolean "accessible"
    t.boolean "available"
    t.integer "inn_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
  end

  create_table "seasonals", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.float "special_price"
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seasonals_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type"
    t.string "document"
    t.string "full_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "document"
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_visitors_on_reservation_id"
  end

  add_foreign_key "inns", "users"
  add_foreign_key "reservations", "rooms"
  add_foreign_key "reservations", "users"
  add_foreign_key "rooms", "inns"
  add_foreign_key "seasonals", "rooms"
  add_foreign_key "visitors", "reservations"
end
