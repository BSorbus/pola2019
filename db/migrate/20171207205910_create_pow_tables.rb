class CreatePowTables < ActiveRecord::Migration[5.1]
  def change
    create_table :pow_tables do |t|
      t.integer :year, null: false, default: "", index: true
      t.string :teryt, null: false, default: "", index: true
      t.string :name, null: false, default: "", index: true
      t.string :woj, null: false, default: "", index: true
      t.multi_polygon :geom, null: false, srid: 2180

      t.timestamps
    end

    change_table :pow_tables do |t|
      t.index :geom, using: :gist
    end

  end
end
