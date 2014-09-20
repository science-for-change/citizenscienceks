class CreateSckDevices < ActiveRecord::Migration
  def self.up
    create_table :sck_devices do |t|
      t.string :SCK_id
      t.string :SCK_API_key
      t.string :title
      t.string :description
      t.string :location
      t.string :city
      t.string :country
      t.string :exposure
      t.decimal :elevation
      t.decimal :geo_lat
      t.decimal :geo_long
      t.datetime :created
      t.datetime :last_insert_datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :sck_devices
  end
end
