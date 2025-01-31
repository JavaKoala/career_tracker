class RemoveDescriptionFromPosition < ActiveRecord::Migration[8.0]
  def change
    remove_column :positions, :description, :text
  end
end
