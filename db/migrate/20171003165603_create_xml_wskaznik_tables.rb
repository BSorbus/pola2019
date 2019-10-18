class CreateXmlWskaznikTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_wskaznik_tables do |t|
      t.references :xml_projekt_table, foreign_key: true
      t.integer :numer
      t.string :nazwa_id
      t.string :nazwa_kod
      t.string :nazwa_opis
      t.string :typ
      t.string :jednostka_miary_opis
      t.string :wartosc_bazowa
      t.string :wartosc_docelowa

      t.timestamps
    end
  end
end
