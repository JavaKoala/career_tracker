require 'rails_helper'

RSpec.describe InterviewsController, type: :request do
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

  describe 'GET /interviews/:id' do
    let(:interview) { create(:interview, job_application: job_application) }

    it 'redirects to the root path if the interview is not found' do
      get '/interviews/0'

      expect(response).to redirect_to(root_path)
    end

    it 'adds an error message if the job application is not found' do
      get '/interviews/0'

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

  describe 'POST /interviews' do
    it 'redirects to the root path if the job application is not found' do
      post interviews_path, params: { interview: { job_application_id: 0 } }

      expect(response).to redirect_to(root_path)
    end

    it 'adds an error message if the job application is not found' do
      post interviews_path, params: { interview: { job_application_id: 0 } }

      expect(flash[:alert]).to eq(I18n.t(:job_application_not_found))
    end

    it 'redirects to the root path if the job application does not belong to the current user' do
      user1 = create(:user, email_address: 'test@test.com')
      job_application.update!(user: user1)

      post interviews_path, params: valid_attributes

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to the job application page' do
      post interviews_path, params: valid_attributes

      expect(response).to redirect_to(job_application_path(job_application))
    end

    it 'creates an interview' do
      expect do
        post interviews_path, params: valid_attributes
      end.to change(Interview, :count).by(1)
    end

    it 'redirects to the job application if not valid' do
      post interviews_path, params: { interview: { job_application_id: job_application.id } }

      expect(response).to redirect_to(job_application_path(job_application))
    end

    it 'adds an error message if not valid' do
      post interviews_path, params: { interview: { job_application_id: job_application.id } }

      expect(flash[:alert]).to eq(
        "Interview start can't be blank, Interview end can't be blank, Location can't be blank"
      )
    end
  end

  describe 'PATCH /interviews/:id' do
    it 'redirects to the root path if the interview is not found' do
      patch '/interviews/0'

      expect(response).to redirect_to(root_path)
    end

    it 'adds an error message if the interview is not found' do
      patch '/interviews/0'

      expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
    end

    it 'redirects to the root path if the job application does not belong to the current user' do
      user1 = create(:user, email_address: 'test@test.com')
      interview = create(:interview, job_application: create(:job_application, user: user1))
      patch interview_path(interview),
            params: { interview: { location: 'In-Person', job_application_id: interview.job_application.id } }

      expect(response).to redirect_to(root_path)
    end

    it 'updates the interview' do
      interview = create(:interview, job_application: job_application)

      patch interview_path(interview),
            params: { interview: { location: 'In-Person', job_application_id: interview.job_application.id } }

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'updates include a flash message' do
      interview = create(:interview, job_application: job_application)

      patch interview_path(interview),
            params: { interview: { location: 'In-Person', job_application_id: interview.job_application.id } }

      expect(flash[:notice]).to eq(I18n.t(:updated_interview))
    end

    it 'redirects to the interview if not valid' do
      interview = create(:interview, job_application: job_application)

      patch interview_path(interview),
            params: { interview: { location: '', job_application_id: interview.job_application.id } }

      expect(response).to redirect_to(interview_path(interview))
    end

    it 'adds an error message if not valid' do
      interview = create(:interview, job_application: job_application)

      patch interview_path(interview),
            params: { interview: { location: '', job_application_id: interview.job_application.id } }

      expect(flash[:alert]).to eq("Location can't be blank")
    end
  end

  describe 'DELETE /interviews/:id' do
    it 'redirects to the root path if the interview is not found' do
      delete '/interviews/0'

      expect(response).to redirect_to(root_path)
    end

    it 'adds an error message if the interview is not found' do
      delete '/interviews/0'

      expect(flash[:alert]).to eq(I18n.t(:interview_not_found))
    end

    it 'redirects to the root path if the job application does not belong to the current user' do
      user1 = create(:user, email_address: 'test@test.com')
      interview = create(:interview, job_application: create(:job_application, user: user1))
      delete interview_path(interview)

      expect(response).to redirect_to(root_path)
    end

    it 'deletes the interview' do
      interview = create(:interview, job_application: job_application)

      expect do
        delete interview_path(interview)
      end.to change(Interview, :count).by(-1)
    end

    it 'redirects to the job application page' do
      interview = create(:interview, job_application: job_application)

      delete interview_path(interview)

      expect(response).to redirect_to(job_application_path(job_application))
    end

    it 'adds a flash message' do
      interview = create(:interview, job_application: job_application)

      delete interview_path(interview)

      expect(flash[:notice]).to eq(I18n.t(:deleted_interview))
    end
  end
end
