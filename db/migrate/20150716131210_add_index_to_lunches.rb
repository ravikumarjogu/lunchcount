class AddIndexToLunches < ActiveRecord::Migration
  def change
      add_index :lunches, [:day, :user_id]
  end
end
