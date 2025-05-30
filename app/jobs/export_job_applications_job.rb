class ExportJobApplicationsJob < ApplicationJob
  queue_as :export

  def perform(user_id)
    ExportJobApplications.new(user_id).perform
  end
end
