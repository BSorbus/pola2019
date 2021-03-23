class ChangeOi10ToPointFiles < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :point_files do |t|
        dir.up { 
          t.change :oi_10, :decimal, precision: 15, scale: 2, index: true  
        }

        dir.down { 
          t.change :oi_10, :integer, index: true 
        }
      end
    end
  end
end
