class JobApplicationsController < ApplicationController
  include Pagy::Backend
  before_action :set_job_application, only: %i[show update]

  def index
    @pagy, @job_applications = pagy(JobApplication.where(user: Current.user))
  end

  def show
    @interview = Interview.new(job_application: @job_application)
    @next_step = NextStep.new(job_application: @job_application)
    redirect_to root_path unless @job_application && @job_application.user == Current.user
  end

  def create
    @job_application = JobApplication.new(job_application_params)
    @job_application.user = Current.user

    if @job_application.save
      redirect_to root_path, notice: t(:job_application_created_successfully)
    else
      redirect_to root_path, alert: @job_application.errors.full_messages.join(', ')
    end
  end

  def update
    if @job_application.blank? || @job_application.user != Current.user
      redirect_to root_path, alert: t(:job_application_not_found)
    elsif @job_application.update(job_application_params)
      redirect_to job_application_path(@job_application)
    else
      redirect_to job_application_path(@job_application), alert: @job_application.errors.full_messages.join(', ')
    end
  end

  private

  def job_application_params
    params.expect(job_application: [:source, :active, :applied, :accepted, :note, :cover_letter, {
                    position_attributes: [
                      :name, :description, :pay_start, :pay_end, :location,
                      { company_attributes: %i[name friendly_name description] }
                    ]
                  }])
  end

  def set_job_application
    @job_application = JobApplication.find_by(id: params[:id])
  end
end
