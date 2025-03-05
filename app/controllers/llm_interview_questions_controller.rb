class LlmInterviewQuestionsController < ApplicationController
  def create
    interview = Interview.find_by(id: params[:interview_id])

    if interview.present?
      CreateLlmInterviewQuestionsJob.perform_later(interview.id, params[:temperature])
      redirect_to interview_path(interview), notice: t(:creating_interview_questions)
    else
      redirect_to root_path, alert: t(:interview_not_found)
    end
  end
end
