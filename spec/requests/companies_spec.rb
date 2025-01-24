require 'rails_helper'

RSpec.describe 'Companies', type: :request do
  describe 'GET /companies' do
    before do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)
    end

    it 'returns http success' do
      get '/companies'
      expect(response).to have_http_status(:success)
    end
  end
end
