class ChangeFieldTypesForGhostWipes < ActiveRecord::Migration
  def self.up
    change_column :ghost_wipes, :As, :string
    change_column :ghost_wipes, :Cd, :string
    change_column :ghost_wipes, :Cr, :string
    change_column :ghost_wipes, :Cu, :string
    change_column :ghost_wipes, :Hg, :string
    change_column :ghost_wipes, :Ni, :string
    change_column :ghost_wipes, :Pb, :string
    change_column :ghost_wipes, :Se, :string
    change_column :ghost_wipes, :Zn, :string
  end

  def self.down
    change_column :ghost_wipes, :As, :float
    change_column :ghost_wipes, :Cd, :float
    change_column :ghost_wipes, :Cr, :float
    change_column :ghost_wipes, :Cu, :float
    change_column :ghost_wipes, :Hg, :float
    change_column :ghost_wipes, :Ni, :float
    change_column :ghost_wipes, :Pb, :float
    change_column :ghost_wipes, :Se, :float
    change_column :ghost_wipes, :Zn, :float
  end
end
