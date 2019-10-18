class CreateEventEffects < ActiveRecord::Migration[5.1]
  def up
    create_table :event_effects do |t|
      t.string :name, index: true

      t.timestamps
    end

		event_effect = EventEffect.create!(name: "Bez wyniku")
		puts 'create EVENT_EFFECT: ' << event_effect.name

		event_effect = EventEffect.create!(name: "Negatywny")
		puts 'create EVENT_EFFECT: ' << event_effect.name

		event_effect = EventEffect.create!(name: "Pozytywny")
		puts 'create EVENT_EFFECT: ' << event_effect.name

		event_effect = EventEffect.create!(name: "Pozytywny z uwagami")
		puts 'create EVENT_EFFECT: ' << event_effect.name

		event_effect = EventEffect.create!(name: "Pozytywny&Negatywny")
		puts 'create EVENT_EFFECT: ' << event_effect.name
  end

  def down
  	drop_table :event_effects
  end

end
