# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140404223838) do

  create_table "import_items", force: true do |t|
    t.integer  "import_id",   null: false
    t.integer  "line_number", null: false
    t.string   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_items", ["import_id", "line_number"], name: "index_import_items_on_import_id_and_line_number", unique: true
  add_index "import_items", ["import_id"], name: "index_import_items_on_import_id"

  create_table "imports", force: true do |t|
    t.string   "name",                       null: false
    t.string   "file_name",                  null: false
    t.boolean  "imported",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchant_locations", force: true do |t|
    t.integer  "merchant_id", null: false
    t.string   "address",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merchant_locations", ["merchant_id", "address"], name: "index_merchant_locations_on_merchant_id_and_address", unique: true
  add_index "merchant_locations", ["merchant_id"], name: "index_merchant_locations_on_merchant_id"

  create_table "merchants", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merchants", ["name"], name: "index_merchants_on_name", unique: true

  create_table "purchasers", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchasers", ["name"], name: "index_purchasers_on_name", unique: true

end
