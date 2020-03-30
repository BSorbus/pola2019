class Archivization < ApplicationRecord

  # relations
  belongs_to :archive
  belongs_to :group
  belongs_to :archivization_type

  # validates
  validates :group_id, presence: true,  
                      uniqueness: { scope: [:archive_id], message: "jest już przypisana do tej Składnicy" }  

  # callbacks

end
