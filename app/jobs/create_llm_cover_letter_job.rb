class CreateLlmCoverLetterJob < ApplicationJob
  queue_as :cover_letter

  def perform(job_application_id)
    CoverLetterLlmService.new(job_application_id).create_cover_letter
  end
end
