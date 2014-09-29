class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do | t |
      t.timestamp :timestamp
      t.float :temp
      t.float :hum
      t.float :co
      t.float :no2
      t.float :light
      t.float :noise
      t.float :bat
      t.float :panel
      t.float :nets
      t.timestamp :insert_datetime
      t.references :sck_device
    end
  end

  def self.down
    drop_table :posts
  end
end
