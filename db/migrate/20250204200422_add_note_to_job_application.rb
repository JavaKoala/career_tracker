class AddNoteToJobApplication < ActiveRecord::Migration[8.0]
  def change
    add_column :job_applications, :note, :text
  end
end
