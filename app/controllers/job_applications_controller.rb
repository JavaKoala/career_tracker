class JobApplicationsController < ApplicationController
  def create
    @job_application = JobApplication.new(job_application_params)
    @job_application.user = Current.user

    if @job_application.save
      redirect_to root_path, notice: t(:job_application_created_successfully)
    else
      redirect_to root_path, alert: @job_application.errors.full_messages.join(', ')
    end
  end

  private

  def job_application_params
    params.expect(job_application: [position_attributes: [:name, :description, :pay_start, :pay_end,
                                                          { company_attributes: [:name] }]])
  end
end
