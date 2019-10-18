class CreateXmlProjektTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_projekt_tables do |t|
      t.references :proposal_file, foreign_key: true
      t.string :do_tytul
      t.date :do_okres_realizacji_data_od
      t.date :do_okres_realizacji_data_do
      t.date :do_okres_kwalifikowalnosci_wydatkow_data_od
      t.date :do_okres_kwalifikowalnosci_wydatkow_data_do
      t.decimal :mfp_mfo_mf_wydatki_ogolem, precision: 15, scale: 2
      t.decimal :mfp_mfo_mf_wydatki_kwalifikowane, precision: 15, scale: 2
      t.decimal :mfp_mfo_mf_dofinansowanie, precision: 15, scale: 2
      t.decimal :mfp_mfo_mf_procent_dofinansowania, precision: 6, scale: 2
      t.decimal :mfp_mfo_mf_wklad_ue, precision: 15, scale: 2
      t.decimal :mfp_mfo_mf_procent_dofinansowanie_ue, precision: 6, scale: 2
      t.decimal :mfp_mfo_mf_wklad_wlasny, precision: 15, scale: 2

      t.timestamps
    end
  end
end
