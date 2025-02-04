require 'rails_helper'

RSpec.describe InterviewController, type: :request do
  let(:user) { create(:user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:valid_attributes) do
    {
      interview: {
        interview_start: 1.day.from_now,
        interview_end: 1.day.from_now + 1.hour,
        location: 'Zoom',
        job_application_id: job_application.id
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /interview' do
    let(:interview) { create(:interview, job_application: job_application) }

    it 'redirects to the root path if the interview is not found' do
      get '/interview/0'

      expect(response).to redirect_to(root_path)
    end

    it 'adds an error message if the job application is not found' do
      get '/interview/0'

      expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
    end

    it 'redirects to the root path if the job application does not belong to the current user' do
      user1 = create(:user, email_address: 'test@foo.com')
      job_application.update!(user: user1)
      get interview_path(interview)

      expect(response).to redirect_to(root_path)
    end

    it 'returns a success response' do
      get interview_path(interview)

      expect(response).to be_successful
    end
  end

  describe 'POST /interview' do
    it 'redirects to the root path if the job application is not found' do
      post interview_index_path, params: { interview: { job_application_id: 0 } }

      expect(response).to redirect_to(root_path)
    end

    it 'adds an error message if the job application is not found' do
      post interview_index_path, params: { interview: { job_application_id: 0 } }

      expect(flash[:alert]).to eq(I18n.t(:job_application_not_found))
    end

    it 'redirects to the root path if the job application does not belong to the current user' do
      user1 = create(:user, email_address: 'test@test.com')
      job_application.update!(user: user1)

      post interview_index_path, params: valid_attributes

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to the job application page' do
      post interview_index_path, params: valid_attributes

      expect(response).to redirect_to(job_application_path(job_application))
    end

    it 'creates an interview' do
      expect do
        post interview_index_path, params: valid_attributes
      end.to change(Interview, :count).by(1)
    end

    it 'redirects to the job application if not valid' do
      post interview_index_path, params: { interview: { job_application_id: job_application.id } }

      expect(response).to redirect_to(job_application_path(job_application))
    end

    it 'adds an error message if not valid' do
      post interview_index_path, params: { interview: { job_application_id: job_application.id } }

      expect(flash[:alert]).to eq(
        "Interview start can't be blank, Interview end can't be blank, Location can't be blank"
      )
    end
  end
end
