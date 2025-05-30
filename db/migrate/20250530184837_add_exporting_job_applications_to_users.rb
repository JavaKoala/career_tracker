class AddExportingJobApplicationsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :exporting_job_applications, :boolean, default: false, null: false
  end
end
