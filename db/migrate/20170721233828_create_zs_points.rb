class CreateZsPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :zs_points do |t|
      t.references :point_file, foreign_key: true
      t.string :zs_2,  limit:  10, index: true
      t.string :zs_3,  limit: 100, index: true
      t.string :zs_4,  limit: 100, index: true
      t.string :zs_5,  limit: 100, index: true
      t.string :zs_6,  limit: 100, index: true
      t.string :zs_7,  limit:   7, index: true
      t.string :zs_8,  limit: 100, index: true
      t.string :zs_9,  limit:   7, index: true
      t.string :zs_10, limit: 250, index: true
      t.string :zs_11, limit:   5, index: true
      t.string :zs_12, limit:  50, index: true
      t.decimal :zs_13, precision: 7, scale: 4, index: true
      t.decimal :zs_14, precision: 7, scale: 4, index: true
      t.string :zs_15, limit: 100, index: true
      t.integer :zs_16, index: true
      t.integer :zs_17, index: true
      t.string :zs_18, limit: 100, index: true
      t.integer :zs_19, index: true
      t.integer :zs_20, index: true
      t.integer :zs_21, index: true

      # t.timestamps
    end
  end
end
