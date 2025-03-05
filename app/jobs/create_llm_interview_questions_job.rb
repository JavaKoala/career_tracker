class CreateLlmInterviewQuestionsJob < ApplicationJob
  queue_as :llm

  def perform(interview_id, temperature)
    Ai::InterviewQuestions.new(interview_id, temperature).create_interview_questions
  end
end
