module JobApplications
  extend ActiveSupport::Concern

  included do
    helper_method :find_job_application
  end

  private

  def find_job_application(job_application_id)
    @job_application = JobApplication.find_by(id: job_application_id, user: Current.user)

    redirect_to root_path, alert: t(:job_application_not_found) if @job_application.blank?
  end
end
