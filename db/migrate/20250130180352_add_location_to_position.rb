class AddLocationToPosition < ActiveRecord::Migration[8.0]
  def change
    change_table :positions do |t|
      t.integer :location, null: false, default: 0
    end
  end
end
