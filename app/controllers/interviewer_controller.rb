class InterviewerController < ApplicationController
  before_action :set_interview, only: %i[create]

  def create
    @interviewer = Interviewer.new(interviewer_params)

    if @interview.blank? || @interview.user != Current.user
      redirect_to root_path, alert: t(:interview_not_found)
    elsif @interviewer.save
      redirect_to interview_path(@interview)
    else
      redirect_to interview_path(@interview), alert: @interviewer.errors.full_messages.join(', ')
    end
  end

  private

  def interviewer_params
    params.expect(
      interviewer: [:interview_id, { person_attributes: %i[name email_address company_id] }]
    )
  end

  def set_interview
    @interview = Interview.find_by(id: interviewer_params[:interview_id])
  end
end
