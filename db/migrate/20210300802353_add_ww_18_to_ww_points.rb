class AddWw18ToWwPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :ww_points, :ww_18, :decimal, index: true
    add_column :ww_points, :ww_19, :decimal, precision: 8, scale: 2, index: true
  end
end
