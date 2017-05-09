# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170509165358) do

  create_table "audits", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "difference", default: 0
    t.integer "drink"
    t.integer "user"
  end

  create_table "barcodes", id: :string, force: :cascade do |t|
    t.integer "drink", null: false
    t.index ["id"], name: "sqlite_autoindex_barcodes_1", unique: true
  end

  create_table "drinks", force: :cascade do |t|
    t.string "name"
    t.decimal "bottle_size", precision: 20, scale: 2, default: "0.0"
    t.integer "caffeine"
    t.integer "price", default: 150
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
    t.integer "balance", default: 0
    t.boolean "active", default: true
    t.boolean "audit", default: false
    t.boolean "redirect", default: true
  end

end
