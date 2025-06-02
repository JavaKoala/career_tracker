class ImportJobApplicationsJob < ApplicationJob
  queue_as :import

  def perform(user_id)
    ImportJobApplications.new(user_id).perform
  end
end
