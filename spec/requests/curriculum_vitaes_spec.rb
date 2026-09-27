require 'rails_helper'

RSpec.describe 'CurriculumVitaes', type: :request do
  let(:user) { create(:user) }

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

  describe 'GET /create' do
    it 'returns http success' do
      get '/curriculum_vitaes/create'
      expect(response).to have_http_status(:success)
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
