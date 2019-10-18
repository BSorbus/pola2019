class Transport < ApplicationRecord

  # relations
  belongs_to :business_trip, inverse_of: :transports
  belongs_to :transport_type

  # validates
  validates :transport_type, presence: true,
                    uniqueness: { scope: [:business_trip_id], message: " - taki środek transportu jest już zdefiniowany w tym Poleceniu Wyjazdu" }

end
