class AddExerciseDateToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :opinion_date, :date
    add_column :events, :rating_date, :date
    add_column :events, :last_activity_date, :date
    add_column :events, :post_audit_information_date, :date
    add_column :events, :exercise_date, :date
  end
end
