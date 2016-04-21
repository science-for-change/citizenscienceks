class CreateSidepackSessionReadings < ActiveRecord::Migration
  def self.up
    create_table :sidepack_session_readings do |t|
      t.references :sidepack_session
      t.timestamp :reading_timestamp
      t.float :reading
    end
  end

  def self.down
    drop_table :sidepack_session_readings
  end
end
