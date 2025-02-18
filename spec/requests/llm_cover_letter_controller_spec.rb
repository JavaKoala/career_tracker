require 'rails_helper'

RSpec.describe LlmCoverLetterController, type: :request do
  let(:user) { create(:user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:valid_attributes) { { job_application_id: job_application.id } }

  before do
    ActiveJob::Base.queue_adapter = :test
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'POST /llm_cover_letter/' do
    context 'with valid parameters' do
      it 'enqueues a job for the llm to create the cover letter' do
        expect do
          post '/llm_cover_letter', params: valid_attributes
        end.to have_enqueued_job(CreateLlmCoverLetterJob).with(job_application.id)
      end

      it 'redirects to the job application' do
        post '/llm_cover_letter', params: valid_attributes

        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'with invalid parameters' do
      it 'redirects to the root path' do
        post '/llm_cover_letter', params: { job_application_id: 0 }

        expect(response).to redirect_to(root_path)
      end

      it 'displays an alert message' do
        post '/llm_cover_letter', params: { job_application_id: 0 }

        expect(flash[:alert]).to eq(I18n.t(:job_application_not_found))
      end
    end
  end
end
