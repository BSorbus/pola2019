class TransportType < ApplicationRecord

  # relations
  has_many :transports, dependent: :nullify
  has_many :roads, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

end
