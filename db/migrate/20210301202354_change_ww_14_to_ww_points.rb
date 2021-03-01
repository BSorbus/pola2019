class ChangeWw14ToWwPoints < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      change_table :ww_points do |t|
        dir.up { 
          t.change :ww_14, :decimal, precision: 11, scale: 8, index: true  
          t.change :ww_15, :decimal, precision: 11, scale: 8, index: true  
        }

        dir.down { 
          t.change :ww_14, :decimal, precision: 7, scale: 4, index: true 
          t.change :ww_15, :decimal, precision: 7, scale: 4, index: true 
        }
      end
    end
  end
end
