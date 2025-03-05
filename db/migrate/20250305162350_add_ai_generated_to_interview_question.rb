class AddAiGeneratedToInterviewQuestion < ActiveRecord::Migration[8.0]
  def change
    add_column :interview_questions, :ai_generated, :boolean, null: false, default: false
  end
end
