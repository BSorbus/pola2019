class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :sec22_rate
      t.text :sec22
      t.boolean :sec23_rate
      t.text :sec23
      t.boolean :sec24_rate
      t.text :sec24
      t.boolean :sec25_rate
      t.text :sec25
      t.boolean :sec28_rate
      t.text :sec28
      t.decimal :sec33_rate, precision: 6, scale: 2
      t.text :sec41
      t.text :sec42
      t.text :sec43
      t.boolean :sec51_rate
      t.text :sec51
      t.boolean :sec61_rate
      t.text :sec61
      t.text :note, default: ""

      t.timestamps
    end
  end
end
