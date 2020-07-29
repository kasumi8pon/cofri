# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_30_065454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_group_id"
    t.integer "position"
    t.index ["user_group_id"], name: "index_food_categories_on_user_group_id"
  end

  create_table "foods", force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "food_category_id"
    t.bigint "user_group_id"
    t.boolean "to_buy", default: false
    t.index ["food_category_id"], name: "index_foods_on_food_category_id"
    t.index ["user_group_id"], name: "index_foods_on_user_group_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "invitation_digest"
    t.boolean "sign_up", default: false
    t.bigint "user_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_group_id"], name: "index_invitations_on_user_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_group_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_group_id"], name: "index_users_on_user_group_id"
  end

  add_foreign_key "food_categories", "user_groups"
  add_foreign_key "foods", "food_categories"
  add_foreign_key "foods", "user_groups"
  add_foreign_key "invitations", "user_groups"
  add_foreign_key "users", "user_groups"
end
