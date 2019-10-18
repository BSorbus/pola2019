class CreateXmlPartnerTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_partner_tables do |t|
      t.references :proposal_file, foreign_key: true
      t.string :dp_nazwa
      t.string :dp_nip
      t.string :dp_regon
      t.string :dp_as_miejscowosc_id
      t.string :dp_as_miejscowosc_opis
      t.string :dp_as_kod_pocztowy
      t.string :dp_as_ulica_id
      t.string :dp_as_ulica_opis
      t.string :dp_as_nr
      t.string :dp_as_lokal
      t.string :dp_as_telefon
      t.string :dp_as_faks
      t.string :dp_as_email
      t.string :dp_as_epuap
      t.string :numer_wpisu_uke
      t.string :mrp_obszar_realizacji_id
      t.string :mrp_obszar_realizacji_opis
      t.integer :mrp_maksymalna_kwota_dofinansowania
      t.decimal :mrp_maksymalna_intensywnosc_wsparcia, precision: 6, scale: 2

      t.timestamps
    end
  end
end
