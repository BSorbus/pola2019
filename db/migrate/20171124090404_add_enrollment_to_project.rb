class AddEnrollmentToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :enrollment, foreign_key: true, index: true
  end
end
