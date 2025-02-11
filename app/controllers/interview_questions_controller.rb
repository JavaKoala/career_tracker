class InterviewQuestionsController < ApplicationController
  before_action :set_interview, only: %i[create update]
  before_action :set_interview_question, only: %i[update destroy]

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

  def update
    if @interview.blank? || @interview_question.blank?
      redirect_to root_path, alert: t(:interview_not_found)
    elsif @interview_question.update(interview_question_params)
      redirect_to interview_path(@interview)
    else
      redirect_to interview_path(@interview), alert: @interview_question.errors.full_messages.join(', ')
    end
  end

  def destroy
    if @interview_question.blank? || @interview_question.user != Current.user
      redirect_to root_path, alert: t(:interview_question_not_found)
    else
      @interview_question.destroy
      redirect_to interview_path(@interview_question.interview), notice: t(:deleted_interview_question)
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

  def set_interview_question
    @interview_question = InterviewQuestion.find_by(id: params[:id])
  end
end
