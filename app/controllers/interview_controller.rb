class InterviewController < ApplicationController
  before_action :set_job_application, only: %i[create update]
  before_action :set_interview, only: %i[show update destroy]

  def show
    if @interview.blank? || @interview.user != Current.user
      redirect_to root_path, alert: t(:interview_not_found)
    else
      @interviewer = Interviewer.new(interview: @interview, person: Person.new)
      @interview_question = InterviewQuestion.new(interview: @interview)
    end
  end

  def create
    @interview = Interview.new(interview_params)

    if @job_application.blank?
      redirect_to root_path, alert: t(:job_application_not_found)
    elsif @interview.save
      redirect_to job_application_path(@interview.job_application)
    else
      redirect_to job_application_path(@interview.job_application), alert: @interview.errors.full_messages.join(', ')
    end
  end

  def update
    if @interview.blank? || @job_application.blank?
      redirect_to root_path, alert: t(:interview_not_found)
    elsif @interview.update(interview_params)
      redirect_to interview_path(@interview), notice: t(:updated_interview)
    else
      redirect_to interview_path(@interview), alert: @interview.errors.full_messages.join(', ')
    end
  end

  def destroy
    if @interview.blank? || @interview.user != Current.user
      redirect_to root_path, alert: t(:interview_not_found)
    else
      @interview.destroy
      redirect_to job_application_path(@interview.job_application), notice: t(:deleted_interview)
    end
  end

  private

  def interview_params
    params.expect(interview: %i[interview_start interview_end location job_application_id])
  end

  def set_job_application
    @job_application = JobApplication.find_by(id: params.dig(:interview, :job_application_id), user: Current.user)
  end

  def set_interview
    @interview = Interview.find_by(id: params[:id])
  end
end
