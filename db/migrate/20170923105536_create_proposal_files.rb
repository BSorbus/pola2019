class CreateProposalFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :proposal_files do |t|
      t.references :project, foreign_key: true
      t.datetime :load_date, index: true
      t.string :load_file
      t.integer :status, index: true
      t.text :note

      t.timestamps
    end
  end
end
