class CreateXmlMiejsceRealizacjiTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_miejsce_realizacji_tables do |t|
      t.references :xml_partner_table, foreign_key: true
      t.string :wojewodztwo_id
      t.string :wojewodztwo_opis
      t.boolean :czy_na_terenie_calego_wojewodztwa
      t.string :powiat_id
      t.string :powiat_opis
      t.boolean :czy_na_terenie_calego_powiatu
      t.string :gmina_id
      t.string :gmina_opis

      t.timestamps
    end
  end
end
