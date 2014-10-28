class AddDatesAndInstallersToDiffusionTubes < ActiveRecord::Migration
  def self.up
    add_column :diffusion_tubes, :date_installed, :date
    add_column :diffusion_tubes, :date_removed, :date
    add_column :diffusion_tubes, :staff_involved, :text
  end

  def self.down
    remove_column :diffusion_tubes, :date_installed
    remove_column :diffusion_tubes, :date_removed
    remove_column :diffusion_tubes, :staff_involved
  end
end
