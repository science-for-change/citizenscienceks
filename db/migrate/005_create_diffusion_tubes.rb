class CreateDiffusionTubes < ActiveRecord::Migration
  def self.up
    create_table :diffusion_tubes do |t|
      t.string :no2_label
      t.string :so2_label
      t.float :tube_height
      t.float :exposure_hours
      t.float :µg_s_total
      t.float :µg_s_blank
      t.float :so2_µg_m3
      t.float :so2_µg_ppb
      t.float :mg_m3
      t.float :ppb
      t.float :no2_µg
      t.references :site
      t.timestamps
    end
  end

  def self.down
    drop_table :diffusion_tubes
  end
end
