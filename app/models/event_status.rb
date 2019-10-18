class EventStatus < ApplicationRecord

  EVENT_STATUS_OPENED = 1
  EVENT_STATUS_VERIFICATION_UKE = 2
  EVENT_STATUS_CLOSED = 3
  EVENT_STATUS_VERIFICATION_CPPC = 4
  EVENT_STATUS_CANCELED = 5

  # relations
  has_many :events, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

  # scope
  scope :status_can_change, -> { where(id: [EVENT_STATUS_OPENED, EVENT_STATUS_VERIFICATION_UKE]) }

end
