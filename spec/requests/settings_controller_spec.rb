require 'rails_helper'

RSpec.describe SettingsController, type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /settings' do
    it 'returns http success' do
      get settings_path
      expect(response).to have_http_status(:success)
    end
  end
end
