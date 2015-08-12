class CreateLunches < ActiveRecord::Migration
  def change
    create_table :lunches do |t|
      t.date :day
      t.string :name
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :lunches, :users
  end
end
