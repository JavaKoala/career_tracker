require 'rails_helper'

RSpec.describe PositionController, type: :request do
  let(:user) { create(:user) }
  let(:position) { create(:position) }
  let(:position_params) do
    {
      position: {
        name: 'Software Developer',
        description: 'New Description',
        pay_start: 90_000,
        pay_end: 130_000,
        location: :remote
      }
    }
  end

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

  describe 'PATCH /position/:id' do
    it 'redirects on invalid position id' do
      patch '/position/0', params: position_params

      expect(response).to redirect_to root_path
    end

    it 'renders flash on invalid position id' do
      patch '/position/0', params: position_params

      expect(flash[:alert]).to eq(I18n.t(:position_not_found))
    end

    it 'returns a success response' do
      patch position_path(position), params: position_params

      expect(response).to redirect_to(position_path(position))
    end

    it 'returns a success flash message' do
      patch position_path(position), params: position_params

      expect(flash[:notice]).to eq('Updated position')
    end

    it 'updates position attributes' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      patch position_path(position), params: position_params

      position.reload

      expect(position.name).to eq('Software Developer')
      expect(position.description).to eq('New Description')
      expect(position.pay_start).to eq(90_000)
      expect(position.pay_end).to eq(130_000)
      expect(position.location).to eq('remote')
    end

    it 'redirects on invalid position params' do
      patch position_path(position), params: { position: { name: '', description: '' } }

      expect(response).to redirect_to(position_path(position))
    end

    it 'renders flash on invalid position params' do
      patch position_path(position), params: { position: { name: '', description: '' } }

      expect(flash[:alert]).to eq("Name can't be blank, Description can't be blank")
    end
  end
end
