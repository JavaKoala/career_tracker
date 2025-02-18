class CreateLlmCoverLetterJob < ApplicationJob
  queue_as :llm

  def perform(job_application_id)
    CoverLetterLlmService.new(job_application_id).create_cover_letter
  end
end
