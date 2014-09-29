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

ActiveRecord::Schema.define(version: 3) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
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

  create_table "sck_devices", force: true do |t|
    t.string   "SCK_id"
    t.string   "SCK_API_key"
    t.string   "title"
    t.string   "description"
    t.string   "location"
    t.string   "city"
    t.string   "country"
    t.string   "exposure"
    t.decimal  "elevation"
    t.decimal  "geo_lat"
    t.decimal  "geo_long"
    t.datetime "created"
    t.datetime "last_insert_datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
