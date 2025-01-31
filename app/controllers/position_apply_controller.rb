class PositionApplyController < ApplicationController
  before_action :set_job_application, only: %i[create]

  def create
    if @position.blank?
      redirect_to root_path, alert: t(:position_not_found)
    elsif @job_application.save
      redirect_to job_application_path(@job_application), notice: t(:job_application_created_successfully)
    else
      redirect_to position_path(@position), alert: @job_application.errors.full_messages.join(', ')
    end
  end

  private

  def position_apply_params
    params.expect(position: [:position_id])
  end

  def set_job_application
    @position = Position.find_by(id: position_apply_params[:position_id])
    @job_application = JobApplication.new(
      source: 'default',
      position: @position,
      user: Current.user
    )
  end
end
