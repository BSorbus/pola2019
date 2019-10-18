class CreateXmlWybranaTechnologiaTables < ActiveRecord::Migration[5.1]
  def change
    create_table :xml_wybrana_technologia_tables do |t|
      t.references :xml_projekt_table, foreign_key: true
      t.string :element_id
      t.string :element_opis

      t.timestamps
    end
  end
end
