class CreateXmlZadanieTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_zadanie_tables do |t|
      t.references :xml_projekt_table, foreign_key: true
      t.string :zadanie
      t.string :numer_zadania
      t.string :nazwa
      t.string :idkm_data_rozpoczecia
      t.string :idkm_planowana_data_zakonczenia

      t.timestamps
    end
  end
end
