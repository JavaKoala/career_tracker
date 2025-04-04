require 'rails_helper'

RSpec.describe PositionsController, type: :request do
  let(:user) { create(:user) }
  let(:position) { create(:position) }
  let(:position_params) do
    {
      position: {
        name: 'Software Developer',
        description: 'New Description',
        pay_start: 90_000,
        pay_end: 130_000,
        location: :remote,
        company_id: position.company_id
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /positions/:id' do
    it 'returns a success response' do
      get position_path(position)

      expect(response).to be_successful
    end

    it 'redirects on invalid position id' do
      get '/positions/0'

      expect(response).to redirect_to root_path
    end

    it 'renders flash on invalid position id' do
      get '/positions/0'

      expect(flash[:alert]).to eq(I18n.t(:position_not_found))
    end
  end

  describe 'POST /position' do
    it 'returns a success response' do
      post positions_path, params: position_params

      expect(response).to redirect_to("/positions/#{Position.last.id}")
    end

    it 'returns a success flash message' do
      post positions_path, params: position_params

      expect(flash[:notice]).to eq('Created position')
    end

    it 'creates a position' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      post positions_path, params: position_params

      position = Position.last

      expect(position.name).to eq('Software Developer')
      expect(position.description.body.to_plain_text).to eq('New Description')
      expect(position.pay_start).to eq(90_000)
      expect(position.pay_end).to eq(130_000)
      expect(position.location).to eq('remote')
    end

    it 'redirects on invalid company params' do
      post positions_path, params: { position: { name: '', company_id: position.company.id } }

      expect(response).to redirect_to(company_path(position.company))
    end

    it 'renders flash on invalid company params' do
      post positions_path, params: { position: { name: '', company_id: position.company.id } }

      expect(flash[:alert]).to eq("Name can't be blank")
    end
  end

  describe 'PATCH /positions/:id' do
    it 'redirects on invalid position id' do
      patch '/positions/0', params: position_params

      expect(response).to redirect_to root_path
    end

    it 'renders flash on invalid position id' do
      patch '/positions/0', params: position_params

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
      expect(position.description.body.to_plain_text).to eq('New Description')
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

      expect(flash[:alert]).to eq("Name can't be blank")
    end
  end
end
