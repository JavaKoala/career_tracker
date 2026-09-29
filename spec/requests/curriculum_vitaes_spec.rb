require 'rails_helper'

RSpec.describe 'CurriculumVitaes', type: :request do
  let(:user) { create(:user) }
  let(:resume_params) do
    {
      curriculum_vitae: {
        resume: {
          basics: {
            name: 'John Doe'
          }
        }
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/curriculum_vitaes/show'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/curriculum_vitaes/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'redirects to resume for success' do
      post curriculum_vitaes_path, params: resume_params

      expect(response).to redirect_to(curriculum_vitae_path(CurriculumVitae.last))
    end

    it 'redirects to new resume for failure' do # rubocop:disable RSpec/ExampleLength
      new_cv = instance_double(CurriculumVitae, save: false,
                                                errors: instance_double(ActiveModel::Errors, full_messages: ['error']))
      allow(CurriculumVitae).to receive(:new).and_return(new_cv)
      allow(new_cv).to receive(:user=)

      post curriculum_vitaes_path, params: resume_params

      expect(response).to redirect_to(new_curriculum_vitae_path)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/curriculum_vitaes/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/curriculum_vitaes/destroy'
      expect(response).to have_http_status(:success)
    end
  end
end
