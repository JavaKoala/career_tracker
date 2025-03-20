class LlmCoverLetterController < ApplicationController
  before_action -> { find_job_application(params[:job_application_id]) }, only: %i[create]

  def create
    CreateLlmCoverLetterJob.perform_later(@job_application.id, params[:temperature])
    redirect_to job_application_path(@job_application), notice: t(:creating_cover_letter)
  end
end
