class AddColsToProposalFile < ActiveRecord::Migration[5.1]
  def change
    add_column :proposal_files, :nabor_id, :string
    add_column :proposal_files, :nabor_opis, :string
    add_column :proposal_files, :rodzaj_id, :string
    add_column :proposal_files, :rodzaj_opis, :string
  end
end
