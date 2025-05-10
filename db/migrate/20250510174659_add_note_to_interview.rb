class AddNoteToInterview < ActiveRecord::Migration[8.0]
  def change
    add_column :interviews, :note, :text
  end
end
