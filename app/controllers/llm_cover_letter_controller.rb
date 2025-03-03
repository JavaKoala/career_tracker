class LlmCoverLetterController < ApplicationController
  def create
    job_application = JobApplication.find_by(id: params[:job_application_id])
    if job_application.present?
      CreateLlmCoverLetterJob.perform_later(job_application.id, params[:temperature])
      redirect_to job_application_path(job_application), notice: t(:creating_cover_letter)
    else
      redirect_to root_path, alert: t(:job_application_not_found)
    end
  end
end
