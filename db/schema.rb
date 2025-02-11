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

ActiveRecord::Schema[7.2].define(version: 2025_02_11_105739) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "currencies", ["USD", "EUR", "JPY", "GBP", "CNY"]
  create_enum "state", ["active", "inactive"]

  create_table "access_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "expired_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_access_sessions_on_product_id"
    t.index ["user_id", "product_id"], name: "index_access_sessions_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_access_sessions_on_user_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "state", default: "active", null: false, enum_type: "state"
    t.index ["name"], name: "index_brands_on_name", unique: true
    t.index ["user_id"], name: "index_brands_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.bigint "user_id", null: false
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "state", default: "active", null: false, enum_type: "state"
    t.enum "currency", default: "USD", null: false, enum_type: "currencies"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.boolean "is_admin", default: false
    t.float "payout_rate", default: 100.0
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "access_sessions", "products"
  add_foreign_key "access_sessions", "users"
  add_foreign_key "brands", "users"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "users"
end
