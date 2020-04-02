class Archivization < ApplicationRecord

  # relations
  belongs_to :archive
  belongs_to :group
  belongs_to :archivization_type

  # validates
  validates :group_id, presence: true,  
                      uniqueness: { scope: [:archive_id, :archivization_type], message: " - jest już przypisana do tej Składnicy z takimi upprawnieniami" }  

  # callbacks

end
