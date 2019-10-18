class CreateTransportTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :transport_types do |t|
      t.string :name

      t.timestamps
    end
    TransportType.find_or_create_by!(name: "PKP II kl.")
    TransportType.find_or_create_by!(name: "Samochód służbowy")
    TransportType.find_or_create_by!(name: "Samolot")
  end
end
