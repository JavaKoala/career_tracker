class AddImportingJobApplicationsToUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :importing_job_applications, default: false, null: false
      t.string :import_error
    end
  end
end
