class CreateLlmCoverLetterJob < ApplicationJob
  queue_as :llm

  def perform(job_application_id, temperature)
    CoverLetterLlmService.new(job_application_id, temperature).create_cover_letter
  end
end
