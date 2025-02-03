class InterviewController < ApplicationController
  before_action :set_job_application, only: %i[create]

  def create
    @interview = Interview.new(interview_params)

    if @job_application.blank?
      redirect_to root_path, alert: t(:job_application_not_found)
    elsif @interview.save
      redirect_to job_application_path(@interview.job_application)
    else
      redirect_to job_application_path(@interview.job_application), alert: @interview.errors.full_messages.join(', ')
    end
  end

  private

  def interview_params
    params.expect(interview: %i[interview_start interview_end location job_application_id])
  end

  def set_job_application
    @job_application = JobApplication.find_by(id: params[:interview][:job_application_id], user: Current.user)
  end
end
