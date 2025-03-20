class JobApplicationsController < ApplicationController
  notifications only: %i[index show]
  include Pagy::Backend
  before_action -> { find_job_application(params[:id]) }, only: %i[show update]

  def index
    @pagy, @job_applications = pagy(Search::JobApplicationSearch.new(params, Current.user).search)
  end

  def show
    @interview = Interview.new(job_application: @job_application)
    @next_step = NextStep.new(job_application: @job_application)
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
    if @job_application.update(job_application_params)
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
end
