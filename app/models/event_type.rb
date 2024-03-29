class EventType < ApplicationRecord

  EVENT_TYPE_OCENA_WNIOSKU = 1
  EVENT_TYPE_OCENA_PROTEST = 2
  EVENT_TYPE_ANALIZA_SAD = 3
  EVENT_TYPE_OPINIA_ZMIAN = 4
  EVENT_TYPE_KONTROLA_REALIZACJA = 5
  EVENT_TYPE_KONTROLA_ZAKONCZENIE = 6
  EVENT_TYPE_KONTROLA_TRWALOSC = 7
  EVENT_TYPE_ANALIZA_DANYCH = 8
  EVENT_TYPE_HURT_CENNIKI = 9
  EVENT_TYPE_INNE = 10
  EVENT_TYPE_OPINIA = 11
  EVENT_TYPE_OPINIA_WSKAZNIKI = 12
 
  # relations
  has_many :events, dependent: :nullify

  # validates
  validates :name, presence: true,
                    length: { in: 1..100 },
                    uniqueness: { case_sensitive: false }


  def access_to_attachments?
    [ EVENT_TYPE_OCENA_WNIOSKU, EVENT_TYPE_OCENA_PROTEST, 
      EVENT_TYPE_OPINIA_ZMIAN, EVENT_TYPE_OPINIA, EVENT_TYPE_OPINIA_WSKAZNIKI, 
      EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_statements?
    [ EVENT_TYPE_OCENA_WNIOSKU, EVENT_TYPE_OCENA_PROTEST, 
      EVENT_TYPE_OPINIA_ZMIAN, EVENT_TYPE_OPINIA, EVENT_TYPE_OPINIA_WSKAZNIKI,
      EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_authorizations?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_correspondences?
    [ EVENT_TYPE_OCENA_WNIOSKU, EVENT_TYPE_OCENA_PROTEST, 
      EVENT_TYPE_OPINIA_ZMIAN, EVENT_TYPE_OPINIA, EVENT_TYPE_OPINIA_WSKAZNIKI,
      EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_ratings?
    [ EVENT_TYPE_OCENA_WNIOSKU, EVENT_TYPE_OCENA_PROTEST ].include?(self.id)
  end

  def access_to_opinions?
    [ EVENT_TYPE_OPINIA_ZMIAN ].include?(self.id)
  end

  def access_to_opinions_wop?
    [ EVENT_TYPE_OPINIA ].include?(self.id)
  end

  def access_to_opinions_wskazniki?
    [ EVENT_TYPE_OPINIA_WSKAZNIKI ].include?(self.id)
  end

  def access_to_protocols?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_inspection_protocols?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_measurements?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_documentations?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_infos?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_photos?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

  def access_to_controlls?
    [ EVENT_TYPE_KONTROLA_REALIZACJA, EVENT_TYPE_KONTROLA_ZAKONCZENIE, EVENT_TYPE_KONTROLA_TRWALOSC ].include?(self.id)
  end

end
