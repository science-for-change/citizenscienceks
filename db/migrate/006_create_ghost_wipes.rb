class CreateGhostWipes < ActiveRecord::Migration
  def self.up
    create_table :ghost_wipes do |t|
      t.string :label
      t.float :As
      t.float :Cd
      t.float :Cr
      t.float :Cu
      t.float :Hg
      t.float :Ni
      t.float :Pb
      t.float :Se
      t.float :Zn
      t.references :site
      t.timestamps
    end
  end

  def self.down
    drop_table :ghost_wipes
  end
end
