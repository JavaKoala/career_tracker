require 'rails_helper'

RSpec.describe InterviewQuestionController, type: :request do
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

  describe 'POST /interview_question' do
    it 'redirects to root path if the interview is not found' do
      post interview_question_index_path, params: { interview_question: { interview_id: 0 } }

      expect(response).to redirect_to(root_path)
    end

    it 'renders a flash message if the interview is not found' do
      post interview_question_index_path, params: { interview_question: { interview_id: 0 } }

      expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
    end

    it 'redirects to root path if the interview does not belong to the current user' do
      user1 = create(:user, email_address: 'test@foo.com')
      job_application.update!(user: user1)
      post interview_question_index_path, params: valid_attributes

      expect(response).to redirect_to(root_path)
    end

    it 'successfully creates an interview question' do
      expect do
        post interview_question_index_path, params: valid_attributes
      end.to change(InterviewQuestion, :count).by(1)
    end

    it 'redirects to the interview page' do
      post interview_question_index_path, params: valid_attributes

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'redirects to the interview page if the interview question is invalid' do
      post interview_question_index_path, params: { interview_question: { question: '', interview_id: interview.id } }

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'renders a flash message if the interview question is invalid' do
      post interview_question_index_path, params: { interview_question: { question: '', interview_id: interview.id } }

      expect(flash[:alert]).to eq("Question can't be blank")
    end
  end
end
