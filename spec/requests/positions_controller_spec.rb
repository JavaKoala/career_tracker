require 'rails_helper'

RSpec.describe PositionsController, type: :request do
  describe 'GET /position' do
    before do
      user = create(:user)
      session = create(:session, user: user)
      allow(Current).to receive(:session).and_return(session)
    end

    it 'returns http success' do
      postion = create(:position)
      get "/positions/#{postion.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
