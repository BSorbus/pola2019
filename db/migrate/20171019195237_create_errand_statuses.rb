class CreateErrandStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :errand_statuses do |t|
      t.string :name

      t.timestamps
    end
    errand_status1 = ErrandStatus.find_or_create_by!(name: "Przekazane do UKE")
    errand_status2 = ErrandStatus.find_or_create_by!(name: "W realizacji")
    errand_status3 = ErrandStatus.find_or_create_by!(name: "Weryfikacja")
    errand_status4 = ErrandStatus.find_or_create_by!(name: "Zakończone")
  end
end
