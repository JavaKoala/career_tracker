class NextStepsController < ApplicationController
  notifications only: %i[index]
  include Pagy::Backend
  before_action :set_job_application, only: %i[create]
  before_action :set_next_step, only: %i[update destroy]

  def index
    @pagy, @next_steps = pagy(NextStep.ready_next_steps(Current.user))
  end

  def create
    redirect_to root_path, alert: t(:job_application_not_found) and return if @job_application.blank?

    next_step = NextStep.new(next_step_params)
    @next_step_errors = next_step.errors.full_messages.join(', ') unless next_step.save
    @next_step = NextStep.new(job_application: @job_application)

    respond_to_turbo_stream
  end

  def update
    redirect_to root_path, alert: t(:next_step_not_found) and return if @next_step.blank?

    unless @next_step.update(next_step_params.except(:job_application_id))
      @next_step_errors = @next_step.errors.full_messages.join(', ')
    end

    respond_to_turbo_stream
  end

  def destroy
    redirect_to root_path, alert: t(:next_step_not_found) and return if @next_step.blank?

    @job_application = @next_step.job_application
    @next_step.destroy

    respond_to_turbo_stream
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
    @next_step = next_step if next_step&.user == Current.user
  end

  def respond_to_turbo_stream
    find_notifications

    respond_to do |format|
      format.turbo_stream
    end
  end
end
