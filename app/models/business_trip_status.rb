class BusinessTripStatus < ApplicationRecord

  BUSINESS_TRIP_STATUS_PROPOSAL = 1
  BUSINESS_TRIP_STATUS_APPROVED = 2
  BUSINESS_TRIP_STATUS_PROPOSAL_PAYMENT = 3
  BUSINESS_TRIP_STATUS_PAYMENT_APPROVED = 4
  BUSINESS_TRIP_STATUS_SUPPLEMENTED = 3
  BUSINESS_TRIP_STATUS_CHECKED = 5
  BUSINESS_TRIP_STATUS_CLOSED = 5

  # relations
  has_many :business_trips, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

  # scope
  scope :status_can_approved, -> { where(id: [BUSINESS_TRIP_STATUS_PROPOSAL]) }
  scope :status_can_change, -> { where(id: [EVENT_STATUS_OPENED, EVENT_STATUS_VERIFICATION_UKE]) }

end
