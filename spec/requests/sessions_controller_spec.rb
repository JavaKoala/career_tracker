require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe 'GET /session/new' do
    it 'returns http success' do
      get '/session/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /session' do
    it 'creates a new session for user' do
      user = create(:user)

      post '/session', params: { email_address: user.email_address, password: 'password' }

      expect(user.sessions).not_to be_empty
    end

    it 'redirects on successful login' do
      user = create(:user)

      post '/session', params: { email_address: user.email_address, password: 'password' }

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to the login page on failed login' do
      user = create(:user)

      post '/session', params: { email_address: user.email_address, password: 'wrong' }

      expect(response).to redirect_to(new_session_path)
    end
  end

  describe 'DELETE /session' do
    it 'destroys the current session' do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)

      delete '/session'

      expect(user.sessions).to be_empty
    end

    it 'redirects to the login page' do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)

      delete '/session'

      expect(response).to redirect_to(new_session_path)
    end
  end
end
