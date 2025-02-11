class UpdateHomeCalendarInterviewEventJob < ApplicationJob
  queue_as :default

  def perform(interview_id)
    HomeCalendarInterviewService.new.update_event(interview_id)
  end
end
