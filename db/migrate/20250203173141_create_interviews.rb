class CreateInterviews < ActiveRecord::Migration[8.0]
  def change
    create_table :interviews do |t|
      t.datetime :interview_start
      t.datetime :interview_end
      t.string :location
      t.references :job_application, null: false, foreign_key: true

      t.timestamps
    end
  end
end
