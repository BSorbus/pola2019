class AddWw17ToWwPoints < ActiveRecord::Migration[5.2]
  def change
    add_column :ww_points, :ww_17, :string, limit: 100, index: true
  end
end
