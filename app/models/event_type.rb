class EventType < ApplicationRecord

  # relations
  has_many :events, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }

end
