class DeleteHomeCalendarInterviewEventJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    HomeCalendarInterviewService.new.delete_event(event_id)
  end
end
