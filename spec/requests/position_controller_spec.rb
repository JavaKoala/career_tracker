require 'rails_helper'

RSpec.describe PositionController, type: :request do
  let(:user) { create(:user) }
  let(:position) { create(:position) }

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /position/:id' do
    it 'returns a success response' do
      get position_path(position)

      expect(response).to be_successful
    end

    it 'redirects on invalid position id' do
      get '/position/0'

      expect(response).to redirect_to root_path
    end

    it 'renders flash on invalid position id' do
      get '/position/0'

      expect(flash[:alert]).to eq(I18n.t(:position_not_found))
    end
  end
end
