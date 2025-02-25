class NextStepsController < ApplicationController
  before_action :set_job_application, only: %i[create update]
  before_action :set_next_step, only: %i[update]

  def create
    redirect_to root_path, alert: t(:job_application_not_found) and return if @job_application.blank?

    next_step = NextStep.new(next_step_params)
    @next_step_errors = next_step.errors.full_messages.join(', ') unless next_step.save
    @next_step = NextStep.new(job_application: @job_application)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update
    redirect_to root_path, alert: t(:next_step_not_found) and return if @next_step.blank?

    @next_step_errors = @next_step.errors.full_messages.join(', ') unless @next_step.update(next_step_params)

    respond_to do |format|
      format.turbo_stream
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

  def set_next_step
    next_step = NextStep.find_by(id: params[:id])
    return if next_step.blank? || @job_application.blank?

    @next_step = next_step if next_step.job_application == @job_application
  end
end
