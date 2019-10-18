class ErrandStatus < ApplicationRecord

  ERRAND_STATUS_TO_UKE = 1
  ERRAND_STATUS_IN_PROGRESS = 2
  ERRAND_STATUS_VERIFICATION = 3
  ERRAND_STATUS_CLOSED = 4

  # relations
  has_many :errands, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }
end
