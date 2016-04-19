class CreateSidepackSessions < ActiveRecord::Migration
  def self.up
    create_table :sidepack_sessions do |t|
      t.string :model
      t.string :model_number
      t.string :serial_number
      t.string :test_id
      t.string :test_abbreviation
      t.timestamp :start_timestamp
      t.integer :duration
      t.integer :time_constant
      t.integer :log_interval
      t.integer :number_of_points
      t.text :notes
      t.string :statistics_channel
      t.string :units
      t.float :average
      t.float :minimum
      t.timestamp :minimum_timestamp
      t.float :maximum
      t.timestamp :maximum_timestamp
      t.integer :account_id
    end
  end

  def self.down
    drop_table :sidepack_sessions
  end
end
