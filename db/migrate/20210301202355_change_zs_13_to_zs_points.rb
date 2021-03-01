class ChangeZs13ToZsPoints < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :zs_points do |t|
        dir.up { 
          t.change :zs_13, :decimal, precision: 11, scale: 8, index: true  
          t.change :zs_14, :decimal, precision: 11, scale: 8, index: true  
        }

        dir.down { 
          t.change :zs_13, :decimal, precision: 7, scale: 4, index: true 
          t.change :zs_14, :decimal, precision: 7, scale: 4, index: true 
        }
      end
    end
  end
end
