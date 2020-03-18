class EventEffect < ApplicationRecord

  EVENT_EFFECT_LACKS = 1                      # Bez wyniku
  EVENT_EFFECT_NEGATIVE = 2                   # Negatywny
  EVENT_EFFECT_POSITIVE = 3                   # Pozytywny
  EVENT_EFFECT_POSITIVE_WITH_COMMENTS = 4     # Pozytywny z uwagami
  EVENT_EFFECT_POSITIVE_NEGATIVE = 5          # Pozytywny&Negatywny
  EVENT_EFFECT_IP_WITHOUT_RECOMMENDATIONS = 6   # IP bez zalecen
  EVENT_EFFECT_IP_WITH_RECOMMENDATIONS = 7      # IP z zaleceniami
  EVENT_EFFECT_SERVICE_NOTE = 8                 # notatka sluzbowa


  # relations
  has_many :events, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }


  def self.only_for_type(type_id)
    EventEffect.where("#{type_id} = ANY (for_event_types)")
  end

end
