class ExportJobApplicationsController < ApplicationController
  def create
    ExportJobApplicationsJob.perform_later(Current.user.id)

    redirect_to settings_path, notice: t(:job_applications_exporting)
  end
end
