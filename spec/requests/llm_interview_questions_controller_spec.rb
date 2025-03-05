require 'rails_helper'

RSpec.describe LlmInterviewQuestionsController, type: :request do
  let(:user) { create(:user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview) { create(:interview, job_application: job_application) }
  let(:valid_attributes) { { interview_id: interview.id, temperature: '0.5' } }

  before do
    ActiveJob::Base.queue_adapter = :test
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'POST /llm_interview_questions/' do
    context 'with valid parameters' do
      it 'enqueues a job for the llm to create the interview questions' do
        expect do
          post '/llm_interview_questions', params: valid_attributes
        end.to have_enqueued_job(CreateLlmInterviewQuestionsJob).with(interview.id, '0.5')
      end

      it 'redirects to the interview' do
        post '/llm_interview_questions', params: valid_attributes

        expect(response).to redirect_to(interview_path(interview))
      end

      it 'renders a flash message' do
        post '/llm_interview_questions', params: valid_attributes

        expect(flash[:notice]).to eq(I18n.t(:creating_interview_questions))
      end
    end

    context 'with invalid parameters' do
      it 'redirects to the root path' do
        post '/llm_interview_questions', params: { interview_id: 0, temperature: '0.5' }

        expect(response).to redirect_to(root_path)
      end

      it 'displays an alert message' do
        post '/llm_interview_questions', params: { interview_id: 0, temperature: '0.5' }

        expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
      end
    end
  end
end
