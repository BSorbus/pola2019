class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.boolean :special, null: false, default: false, index: true
      # t.string :activities, array: true, length: 30, using: 'gin', default: '{}'
      t.string :activities, array: true, using: 'gin', default: '{}'
      t.text :note, default: ""

      t.timestamps
    end
  end
end
