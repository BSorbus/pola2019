class ProjectStatus < ApplicationRecord

  PROJECT_STATUS_REGISTERED = 1
  PROJECT_STATUS_RATING = 2
  PROJECT_STATUS_PROTEST = 3
  PROJECT_STATUS_JUDICIAL_COMPLAINT = 4
  PROJECT_STATUS_REJECTED_POSITIVE = 5
  PROJECT_STATUS_REJECTED_NEGATIVE = 6
  PROJECT_STATUS_REJECTED_NEGATIVE_MER_1 = 7
  PROJECT_STATUS_REJECTED_NEGATIVE_MER_2 = 8
  PROJECT_STATUS_REALIZED = 9
  PROJECT_STATUS_DURABILITY = 10
  PROJECT_STATUS_CLOSED = 11

  # relations
  has_many :projects, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

end
