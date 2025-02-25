class NextStepsController < ApplicationController
  before_action :set_job_application, only: %i[create]

  def create
    redirect_to root_path, alert: t(:job_application_not_found) and return if @job_application.blank?

    next_step = NextStep.new(next_step_params)

    if next_step.save
      respond_to do |format|
        @next_step = NextStep.new(job_application: @job_application)
        format.turbo_stream
      end
    else
      redirect_to job_application_path(@job_application), alert: next_step.errors.full_messages.join(', ')
    end
  end

  private

  def next_step_params
    params.expect(next_step: %i[description done due job_application_id])
  end

  def set_job_application
    application = JobApplication.find_by(id: next_step_params[:job_application_id])
    @job_application = application if application&.user == Current.user
  end
end
