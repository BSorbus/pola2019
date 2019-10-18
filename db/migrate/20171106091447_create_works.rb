class CreateWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :works do |t|
      t.references :trackable, polymorphic: true, index: true
      t.string :trackable_url
#      t.references :user, foreign_key: true, index: true
      t.references :user, foreign_key: false, index: true
      t.string :action
      t.text :parameters

      t.timestamps
    end
  end
end
