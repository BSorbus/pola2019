class AddExerciseDateToErrand < ActiveRecord::Migration[5.2]
  def change
    add_column :errands, :exercise_date, :date
    add_column :errands, :exercise_date_info_number, :string
    add_column :errands, :exercise_date_info_date, :date
  end
end
