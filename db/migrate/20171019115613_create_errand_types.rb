class CreateErrandTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :errand_types do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
