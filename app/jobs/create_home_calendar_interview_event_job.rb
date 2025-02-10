class CreateHomeCalendarInterviewEventJob < ApplicationJob
  queue_as :default

  def perform(interview_id)
    HomeCalendarInterviewService.new(interview_id).create_event
  end
end
