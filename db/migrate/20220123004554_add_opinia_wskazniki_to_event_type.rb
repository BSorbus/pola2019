class AddOpiniaWskaznikiToEventType < ActiveRecord::Migration[5.2]
  def up
  	# to powinno być przy poprzednim
		#name: "Opinia WOP"
		event_type_old = EventType.find(11)
		event_type_old.activities = ["event_type_11:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
		event_type_old.save!


		event_type = EventType.create!(name: "Opinia wskaźniki").tap do |et|
			et.activities = ["event_type_12:*", "event:index", "event:show", "accessorization:index", "comment:index", "comment:show", "errand:index", "errand:show", "project:index", "project:show", "customer:index", "customer:show", "attachment:customer_index", "attachment:customer_show", "attachment:project_index", "attachment:project_show", "attachment:errand_index", "attachment:errand_show", "attachment:event_index", "attachment:event_show", "point_file:index", "point_file:download", "point_file:show", "proposal_file:index", "proposal_file:download", "proposal_file:show"]
			et.save!
			puts 'create EVENT_TYPE: ' << et.name
		end

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
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA,
                            EventType::EVENT_TYPE_OPINIA_WSKAZNIKI ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Negatywny").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA,
                            EventType::EVENT_TYPE_OPINIA_WSKAZNIKI ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Pozytywny").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA,
                            EventType::EVENT_TYPE_OPINIA_WSKAZNIKI ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Pozytywny z uwagami").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA,
                            EventType::EVENT_TYPE_OPINIA_WSKAZNIKI ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Pozytywny&Negatywny").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA,
                            EventType::EVENT_TYPE_OPINIA_WSKAZNIKI ]
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
  end

  def down
		event_type = EventType.find_by(name: "Opinia wskaźniki")
		event_type_name = event_type.name
		puts 'delete EVENT_TYPE: ' << event_type_name if event_type.destroy

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
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Negatywny").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Pozytywny").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Pozytywny z uwagami").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA ]
      ef.save!
    end

    EventEffect.find_or_create_by!(name: "Pozytywny&Negatywny").tap do |ef|
      ef.for_event_types = [ EventType::EVENT_TYPE_OCENA_WNIOSKU,
                            EventType::EVENT_TYPE_OCENA_PROTEST, 
                            EventType::EVENT_TYPE_ANALIZA_SAD, 
                            EventType::EVENT_TYPE_OPINIA_ZMIAN, 
                            EventType::EVENT_TYPE_ANALIZA_DANYCH, 
                            EventType::EVENT_TYPE_HURT_CENNIKI, 
                            EventType::EVENT_TYPE_INNE,
                            EventType::EVENT_TYPE_OPINIA ]
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

  end
end
