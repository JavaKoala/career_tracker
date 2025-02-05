class CreateInterviewers < ActiveRecord::Migration[8.0]
  def change
    create_table :interviewers do |t|
      t.references :person, null: false, foreign_key: true
      t.references :interview, null: false, foreign_key: true

      t.timestamps
    end
  end
end
