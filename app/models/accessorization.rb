class Accessorization < ApplicationRecord

  # relations
  belongs_to :event, touch: true
  belongs_to :user
  belongs_to :role #, -> { only_not_special }

  # validates
  validates :user_id, presence: true,  
                      uniqueness: { scope: [:event_id], message: "jest już przypisany do tego zadania" }  
  #validates_presence_of :project
  #validates_presence_of :user
  #validates_presence_of :role

  # callbacks

end
