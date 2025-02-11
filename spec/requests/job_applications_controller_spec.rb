require 'rails_helper'

RSpec.describe JobApplicationsController, type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      job_application: {
        position_attributes: {
          name: 'Software Engineer',
          description: 'A great job',
          pay_start: 50_000,
          pay_end: 100_000,
          location: :remote,
          company_attributes: {
            name: 'Google',
            friendly_name: 'Google Inc.',
            description: 'Search engine'
          }
        },
        source: 'LinkedIn'
      }
    }
  end
  let(:invalid_attributes) do
    {
      job_application: {
        position_attributes: {
          name: '',
          description: 'A great job',
          company_attributes: { name: 'Google' }
        }
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /job_applications' do
    it 'returns a success response' do
      get job_applications_path

      expect(response).to be_successful
    end
  end

  describe 'GET /job_applications/:id' do
    it 'returns a success response' do
      job_application = create(:job_application, user: user)

      get job_application_path(job_application)

      expect(response).to be_successful
    end

    it 'redirects on invalid job application id' do
      get '/job_applications/0'

      expect(response).to redirect_to root_path
    end

    it 'redirects on job application not associated with user' do
      new_user = create(:user, email_address: 'foo1@test.com')
      job_application = create(:job_application, user: new_user)

      get job_application_path(job_application)

      expect(response).to redirect_to root_path
    end
  end

  describe 'POST /job_applications' do
    context 'with valid parameters' do
      it 'creates a new job application' do
        expect do
          post job_applications_path, params: valid_attributes
        end.to change(JobApplication, :count).by(1)
      end

      it 'associates the job application with the current user' do
        post job_applications_path, params: valid_attributes

        expect(JobApplication.last.user).to eq(user)
      end

      it 'sets the pay_start attribute' do
        post job_applications_path, params: valid_attributes

        expect(JobApplication.last.position.pay_start).to eq(50_000)
      end

      it 'sets the pay_end attribute' do
        post job_applications_path, params: valid_attributes

        expect(JobApplication.last.position.pay_end).to eq(100_000)
      end

      it 'sets the location attribute' do
        post job_applications_path, params: valid_attributes

        expect(JobApplication.last.position.location).to eq('remote')
      end

      it 'sets the friendly name attribute' do
        post job_applications_path, params: valid_attributes

        expect(JobApplication.last.position.company.friendly_name).to eq('Google Inc.')
      end

      it 'sets the company description' do
        post job_applications_path, params: valid_attributes

        expect(JobApplication.last.position.company.description).to eq('Search engine')
      end

      it 'redirects to root_path' do
        post job_applications_path, params: valid_attributes

        expect(response).to redirect_to('/')
      end

      it 'sets a flash notice' do
        post job_applications_path, params: valid_attributes

        expect(flash[:notice]).to eq('Job application created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new job application' do
        expect do
          post job_applications_path, params: invalid_attributes
        end.not_to change(JobApplication, :count)
      end

      it 'redirects to root_path' do
        post job_applications_path, params: invalid_attributes

        expect(response).to redirect_to('/')
      end

      it 'does not create duplicate companies' do
        create(:company, name: 'Google')

        expect do
          post job_applications_path, params: valid_attributes
        end.not_to change(Company, :count)
      end

      it 'sets a flash alert' do
        post job_applications_path, params: invalid_attributes

        expect(flash[:alert]).to eq("Position name can't be blank, Source can't be blank")
      end
    end
  end

  describe 'PATCH /job_applications/:id' do
    let(:job_application) { create(:job_application, user: user) }

    context 'with valid parameters' do
      it 'updates the job application' do
        patch job_application_path(job_application), params: { job_application: { active: false } }

        job_application.reload

        expect(job_application.active).to be(false)
      end

      it 'redirects to the job application' do
        patch job_application_path(job_application), params: valid_attributes

        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the job application' do
        patch job_application_path(job_application), params: { job_application: { source: '' } }

        job_application.reload

        expect(job_application.source).not_to eq('')
      end

      it 'sets a flash alert' do
        patch job_application_path(job_application), params: { job_application: { source: '' } }

        expect(flash[:alert]).to eq("Source can't be blank")
      end

      it 'redirects to the job application' do
        patch job_application_path(job_application), params: invalid_attributes

        expect(response).to redirect_to(job_application_path(job_application))
      end
    end

    context 'with invalid job application id' do
      it 'redirects to root_path' do
        patch '/job_applications/0', params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'contains flash message' do
        patch '/job_applications/0', params: valid_attributes

        expect(flash[:alert]).to eq('Job application not found')
      end
    end
  end
end
