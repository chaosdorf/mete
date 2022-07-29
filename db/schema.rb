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

ActiveRecord::Schema.define(version: 2017_09_29_201659) do

  create_table "audits", force: :cascade do |t|
    t.datetime "created_at"
    t.decimal "difference", precision: 20, scale: 2, default: "0.0"
    t.integer "drink"
    t.integer "user"
  end

  create_table "barcodes", id: :string, force: :cascade do |t|
    t.integer "drink", null: false
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name"
    t.decimal "bottle_size", precision: 20, scale: 2, default: "0.0"
    t.integer "caffeine"
    t.decimal "price", precision: 20, scale: 2, default: "0.0"
    t.string "logo_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean "active", default: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "balance", precision: 20, scale: 2, default: "0.0"
    t.boolean "active", default: true
    t.boolean "audit", default: false
    t.boolean "redirect", default: true
  end

end
