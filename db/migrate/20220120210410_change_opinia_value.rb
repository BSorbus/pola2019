class ChangeOpiniaValue < ActiveRecord::Migration[5.2]
  def up
    EventType.find_by!(name: "Opinia").tap do |et|
      et.name = "Opinia WOP"
      et.save!
    end
  end

  def down
    EventType.find_by!(name: "Opinia WOP").tap do |et|
      et.name = "Opinia"
      et.save!
    end

  end
end
