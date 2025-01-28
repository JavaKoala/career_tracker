require 'rails_helper'

RSpec.describe JobApplicationsController, type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      job_application: {
        position_attributes: {
          name: 'Software Engineer',
          description: 'A great job',
          company_attributes: { name: 'Google' }
        }
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

  describe 'POST /job_applications' do
    context 'with valid parameters' do
      it 'creates a new job application' do
        expect do
          post '/job_applications', params: valid_attributes
        end.to change(JobApplication, :count).by(1)
      end

      it 'associates the job application with the current user' do
        post '/job_applications', params: valid_attributes

        expect(JobApplication.last.user).to eq(user)
      end

      it 'redirects to root_path' do
        post '/job_applications', params: valid_attributes

        expect(response).to redirect_to('/')
      end

      it 'sets a flash notice' do
        post '/job_applications', params: valid_attributes

        expect(flash[:notice]).to eq('Job application created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new job application' do
        expect do
          post '/job_applications', params: invalid_attributes
        end.not_to change(JobApplication, :count)
      end

      it 'redirects to root_path' do
        post '/job_applications', params: invalid_attributes

        expect(response).to redirect_to('/')
      end

      it 'sets a flash alert' do
        post '/job_applications', params: invalid_attributes

        expect(flash[:alert]).to eq("Position name can't be blank")
      end
    end
  end
end
