class ImportJobApplicationsController < ApplicationController
  def update
    @user = Current.user
    if @user.update(import_job_applications_params)
      redirect_to settings_path, notice: t(:importing_job_applications)
    else
      redirect_to settings_path, alert: @user.errors.full_messages.join(', ')
    end
  end

  private

  def import_job_applications_params
    params.expect(user: %i[job_application_import])
  end
end
