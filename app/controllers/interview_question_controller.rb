class InterviewQuestionController < ApplicationController
  before_action :set_interview, only: %i[create]

  def create
    @interview_question = InterviewQuestion.new(interview_question_params)

    if @interview.blank?
      redirect_to root_path, alert: t(:interview_not_found)
    elsif @interview_question.save
      redirect_to interview_path(@interview_question.interview)
    else
      redirect_to interview_path(@interview_question.interview),
                  alert: @interview_question.errors.full_messages.join(', ')
    end
  end

  private

  def interview_question_params
    params.expect(interview_question: %i[question answer interview_id])
  end

  def set_interview
    @interview = Interview.find_by(id: params.dig(:interview_question, :interview_id))
    @interview = nil if @interview&.user != Current.user
  end
end
