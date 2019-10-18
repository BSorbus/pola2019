class CreateWwPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :ww_points do |t|
      t.references :point_file, foreign_key: true
      t.string :ww_2,  limit:  10, index: true
      t.string :ww_3,  limit: 100, index: true
      t.string :ww_4,  limit: 100, index: true
      t.string :ww_5,  limit: 100, index: true
      t.string :ww_6,  limit: 100, index: true
      t.string :ww_7,  limit:   7, index: true
      t.string :ww_8,  limit: 100, index: true
      t.string :ww_9,  limit:   7, index: true
      t.string :ww_10, limit: 250, index: true
      t.string :ww_11, limit:   5, index: true
      t.string :ww_12, limit:  50, index: true
      t.string :ww_13, limit:   6, index: true
      t.decimal :ww_14, precision: 7, scale: 4, index: true
      t.decimal :ww_15, precision: 7, scale: 4, index: true
      t.string :ww_16, limit: 100, index: true

      # t.timestamps
    end
  end
end
