class JobApplicationsController < ApplicationController
  def create
    @job_application = JobApplication.new(job_application_params)
    @job_application.user = Current.user

    @job_application.save!
    redirect_to root_path
  end

  private

  def job_application_params
    params.expect(job_application: [position_attributes: [:name, :description, { company_attributes: [:name] }]])
  end
end
