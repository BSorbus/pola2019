class AddForEventTypesToEventEffect < ActiveRecord::Migration[5.2]
  def change

    reversible do |dir|

      dir.up   { 
        add_column :event_effects, :for_event_types, :integer, array: true, default: []
        add_index :event_effects, :for_event_types, using: 'gin'

        EventEffect.find_or_create_by!(name: "Bez wyniku").tap do |ef|
          # ef.for_event_type << 99 << 88 << 77
          ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                                EventType::EVENT_TYPE_OCENA_PROTEST, 
                                EventType::EVENT_TYPE_ANALIZA_SAD, 
                                EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                                EventType::EVENT_TYPE_KONTROLA_REALIZACJA, 
                                EventType::EVENT_TYPE_KONTROLA_ZAKONCZENIE, 
                                EventType::EVENT_TYPE_KONTROLA_TRWALOSC, 
                                EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                                EventType::EVENT_TYPE_HURT_CENNIKI, 
                                EventType::EVENT_TYPE_INNE ]
          ef.save!
        end

        EventEffect.find_or_create_by!(name: "Negatywny").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                                EventType::EVENT_TYPE_OCENA_PROTEST, 
                                EventType::EVENT_TYPE_ANALIZA_SAD, 
                                EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                                EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                                EventType::EVENT_TYPE_HURT_CENNIKI, 
                                EventType::EVENT_TYPE_INNE ]
          ef.save!
        end

        EventEffect.find_or_create_by!(name: "Pozytywny").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                                EventType::EVENT_TYPE_OCENA_PROTEST, 
                                EventType::EVENT_TYPE_ANALIZA_SAD, 
                                EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                                EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                                EventType::EVENT_TYPE_HURT_CENNIKI, 
                                EventType::EVENT_TYPE_INNE ]
          ef.save!
        end

        EventEffect.find_or_create_by!(name: "Pozytywny z uwagami").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                                EventType::EVENT_TYPE_OCENA_PROTEST, 
                                EventType::EVENT_TYPE_ANALIZA_SAD, 
                                EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                                EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                                EventType::EVENT_TYPE_HURT_CENNIKI, 
                                EventType::EVENT_TYPE_INNE ]
          ef.save!
        end

        EventEffect.find_or_create_by!(name: "Pozytywny&Negatywny").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                                EventType::EVENT_TYPE_OCENA_PROTEST, 
                                EventType::EVENT_TYPE_ANALIZA_SAD, 
                                EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                                EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                                EventType::EVENT_TYPE_HURT_CENNIKI, 
                                EventType::EVENT_TYPE_INNE ]
          ef.save!
        end

        # nowe
        EventEffect.find_or_create_by!(name: "IP bez zaleceń").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_KONTROLA_REALIZACJA, 
                                EventType::EVENT_TYPE_KONTROLA_ZAKONCZENIE, 
                                EventType::EVENT_TYPE_KONTROLA_TRWALOSC ]
          ef.save!
        end

        EventEffect.find_or_create_by!(name: "IP z zaleceniami").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_KONTROLA_REALIZACJA, 
                                EventType::EVENT_TYPE_KONTROLA_ZAKONCZENIE, 
                                EventType::EVENT_TYPE_KONTROLA_TRWALOSC ]
          ef.save!
        end

        EventEffect.find_or_create_by!(name: "Notatka służbowa").tap do |ef|
          ef.for_event_types = [ EventType::EVENT_TYPE_KONTROLA_REALIZACJA, 
                                EventType::EVENT_TYPE_KONTROLA_ZAKONCZENIE, 
                                EventType::EVENT_TYPE_KONTROLA_TRWALOSC ]
          ef.save!
        end


      }

      dir.down   { 
        remove_index :event_effects, :for_event_types
        remove_column :event_effects, :for_event_types
      }

    end

  end
end
