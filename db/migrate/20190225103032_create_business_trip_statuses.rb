class CreateBusinessTripStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :business_trip_statuses do |t|
      t.string :name

      t.timestamps
    end
    BusinessTripStatus.find_or_create_by!(name: "Wniosek")
    BusinessTripStatus.find_or_create_by!(name: "Zakceptawane")
    BusinessTripStatus.find_or_create_by!(name: "Wniosek o zaliczkę")
    BusinessTripStatus.find_or_create_by!(name: "Zatwierdzony wniosek o zaliczkę")
    BusinessTripStatus.find_or_create_by!(name: "Uzupełniane")
    BusinessTripStatus.find_or_create_by!(name: "Zweryfikowane")
    BusinessTripStatus.find_or_create_by!(name: "Zakończone")
  end
end
