class AddSamplingDateAndStaffToGhostWipes < ActiveRecord::Migration
  def self.up
    add_column :ghost_wipes, :sampling_date, :date
    add_column :ghost_wipes, :staff_involved, :text
  end

  def self.down
    remove_column :ghost_wipes, :sampling_date, :date
    remove_column :ghost_wipes, :staff_involved, :text
  end
end
