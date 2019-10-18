class CreateXmlKamienMilowyTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_kamien_milowy_tables do |t|
      t.references :xml_zadanie_table, foreign_key: true
      t.string :nazwa
      t.boolean :czy_oznacza_zakonczenie
      t.string :planowana_data_zakonczenia
      t.string :data_punktu_krytycznego
      t.string :data_punktu_ostatecznego

      t.timestamps
    end
  end
end
