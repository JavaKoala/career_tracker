require 'rails_helper'

RSpec.describe HomeController, type: :request do
  describe 'GET /home' do
    it 'returns redirect without session success' do
      get '/'
      expect(response).to redirect_to('/session/new')
    end

    it 'returns http redirect with session' do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)

      get '/'
      expect(response).to have_http_status(:success)
    end
  end
end
