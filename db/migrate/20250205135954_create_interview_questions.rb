class CreateInterviewQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :interview_questions do |t|
      t.text :question
      t.text :answer
      t.references :interview, null: false, foreign_key: true

      t.timestamps
    end
  end
end
