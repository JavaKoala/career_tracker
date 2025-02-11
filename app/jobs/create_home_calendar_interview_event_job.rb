class CreateHomeCalendarInterviewEventJob < ApplicationJob
  queue_as :default

  def perform(interview_id)
    HomeCalendarInterviewService.new.create_event(interview_id)
  end
end
