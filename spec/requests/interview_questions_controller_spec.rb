require 'rails_helper'

RSpec.describe InterviewQuestionsController, type: :request do
  let(:user) { create(:user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview) { create(:interview, job_application: job_application) }
  let(:valid_attributes) do
    {
      interview_question: {
        question: 'What is your favorite color?',
        interview_id: interview.id
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'POST /interview_questions' do
    it 'redirects to root path if the interview is not found' do
      post interview_questions_path, params: { interview_question: { interview_id: 0 } }

      expect(response).to redirect_to(root_path)
    end

    it 'renders a flash message if the interview is not found' do
      post interview_questions_path, params: { interview_question: { interview_id: 0 } }

      expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
    end

    it 'redirects to root path if the interview does not belong to the current user' do
      user1 = create(:user, email_address: 'test@foo.com')
      job_application.update!(user: user1)
      post interview_questions_path, params: valid_attributes

      expect(response).to redirect_to(root_path)
    end

    it 'successfully creates an interview question' do
      expect do
        post interview_questions_path, params: valid_attributes
      end.to change(InterviewQuestion, :count).by(1)
    end

    it 'redirects to the interview page' do
      post interview_questions_path, params: valid_attributes

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'redirects to the interview page if the interview question is invalid' do
      post interview_questions_path, params: { interview_question: { question: '', interview_id: interview.id } }

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'renders a flash message if the interview question is invalid' do
      post interview_questions_path, params: { interview_question: { question: '', interview_id: interview.id } }

      expect(flash[:alert]).to eq("Question can't be blank")
    end
  end

  describe 'PATCH /interview_questions/:id' do
    let(:interview_question) { create(:interview_question, interview: interview) }

    it 'redirects to root path if the interview is not found' do
      patch interview_question_path(interview_question), params: { interview_question: { interview_id: 0 } }

      expect(response).to redirect_to(root_path)
    end

    it 'renders a flash message if the interview is not found' do
      patch interview_question_path(interview_question), params: { interview_question: { interview_id: 0 } }

      expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
    end

    it 'redirects to the root path if the interview question is not found' do
      patch '/interview_questions/0', params: valid_attributes

      expect(response).to redirect_to(root_path)
    end

    it 'updates an interview question' do
      patch interview_question_path(interview_question), params: valid_attributes

      expect(interview_question.reload.question).to eq(valid_attributes.dig(:interview_question, :question))
    end

    it 'redirects to the interview page' do
      patch interview_question_path(interview_question), params: valid_attributes

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'renders a flash message if the interview question is invalid' do
      patch interview_question_path(interview_question),
            params: { interview_question: { question: '', interview_id: interview.id } }

      expect(flash[:alert]).to eq("Question can't be blank")
    end

    it 'redirects to the interview page if the interview question is invalid' do
      patch interview_question_path(interview_question),
            params: { interview_question: { question: '', interview_id: interview.id } }

      expect(response).to redirect_to(interview_path(interview))
    end
  end

  describe 'DELETE /interview_questions/:id' do
    it 'redirects to the root path if the interview question is not found' do
      delete '/interview_questions/0'

      expect(response).to redirect_to(root_path)
    end

    it 'renders a flash message if the interview is not found' do
      delete '/interview_questions/0'

      expect(flash[:alert]).to eq(I18n.t(:interview_question_not_found))
    end

    it 'redirects to root path if the interview question user is not equal to the current user' do
      user1 = create(:user, email_address: 'test@test.com')
      job_application.update!(user: user1)
      interview_question = create(:interview_question, interview: interview)

      delete interview_question_path(interview_question)

      expect(response).to redirect_to(root_path)
    end

    it 'deletes an interview question' do
      interview_question = create(:interview_question, interview: interview)

      expect do
        delete interview_question_path(interview_question)
      end.to change(InterviewQuestion, :count).by(-1)
    end

    it 'redirects to the interview page' do
      interview_question = create(:interview_question, interview: interview)

      delete interview_question_path(interview_question)

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'renders a flash message if the question is deleted' do
      interview_question = create(:interview_question, interview: interview)

      delete interview_question_path(interview_question)

      expect(flash[:notice]).to eq(I18n.t(:deleted_interview_question))
    end
  end
end
