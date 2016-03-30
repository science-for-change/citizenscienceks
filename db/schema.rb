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

ActiveRecord::Schema.define(version: 12) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "surname",          limit: 255
    t.string   "email",            limit: 255
    t.string   "crypted_password", limit: 255
    t.string   "role",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diffusion_tubes", force: :cascade do |t|
    t.string   "no2_label",      limit: 255
    t.string   "so2_label",      limit: 255
    t.float    "tube_height"
    t.float    "exposure_hours"
    t.float    "µg_s_total"
    t.float    "µg_s_blank"
    t.float    "so2_µg_m3"
    t.float    "so2_µg_ppb"
    t.float    "mg_m3"
    t.float    "ppb"
    t.float    "no2_µg"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_installed"
    t.date     "date_removed"
    t.text     "staff_involved"
  end

  create_table "ghost_wipes", force: :cascade do |t|
    t.string   "label",          limit: 255
    t.string   "As",             limit: 255
    t.string   "Cd",             limit: 255
    t.string   "Cr",             limit: 255
    t.string   "Cu",             limit: 255
    t.string   "Hg",             limit: 255
    t.string   "Ni",             limit: 255
    t.string   "Pb",             limit: 255
    t.string   "Se",             limit: 255
    t.string   "Zn",             limit: 255
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "sampling_date"
    t.text     "staff_involved"
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "timestamp"
    t.float    "temp"
    t.float    "hum"
    t.float    "co"
    t.float    "no2"
    t.float    "light"
    t.float    "noise"
    t.float    "bat"
    t.float    "panel"
    t.float    "nets"
    t.datetime "insert_datetime"
    t.integer  "sck_device_id"
  end

  create_table "sck_devices", force: :cascade do |t|
    t.string   "SCK_id",               limit: 255
    t.string   "SCK_API_key",          limit: 255
    t.string   "title",                limit: 255
    t.string   "description",          limit: 255
    t.string   "location",             limit: 255
    t.string   "city",                 limit: 255
    t.string   "country",              limit: 255
    t.string   "exposure",             limit: 255
    t.decimal  "elevation"
    t.decimal  "geo_lat"
    t.decimal  "geo_long"
    t.datetime "created"
    t.datetime "last_insert_datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "location",   limit: 255
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: :cascade do |t|
    t.text     "file"
    t.integer  "upload_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
