class AddSourceToJobApplication < ActiveRecord::Migration[8.0]
  def change
    add_column :job_applications, :source, :string
  end
end
