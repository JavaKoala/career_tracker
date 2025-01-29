require 'rails_helper'

RSpec.describe CompaniesController, type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company) }

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /companies/:id' do
    it 'returns a success response' do
      get "/companies?id=#{company.id}"

      expect(response).to be_successful
    end

    it 'redirects on invalid company id' do
      get '/companies?id=0'

      expect(response).to redirect_to root_path
    end

    it 'renders flash on invalid company id' do
      get '/companies?id=0'

      expect(flash[:alert]).to eq(I18n.t(:company_not_found))
    end
  end

  describe 'PATCH /companies/:id' do
    let(:company_params) do
      {
        company: {
          name: 'New Name',
          friendly_name: 'New Friendly Name',
          address1: 'New Address 1',
          address2: 'New Address 2',
          city: 'New City',
          state: 'New State',
          county: 'New County',
          zip: 'New Zip',
          country: 'New Country',
          description: 'New Description'
        }
      }
    end

    it 'redirects on invalid company id' do
      patch '/companies?id=0', params: company_params

      expect(response).to redirect_to root_path
    end

    it 'renders flash on invalid company id' do
      patch '/companies?id=0', params: company_params

      expect(flash[:alert]).to eq(I18n.t(:company_not_found))
    end

    it 'returns a success response' do
      patch "/companies?id=#{company.id}", params: company_params

      expect(response).to redirect_to("/companies?id=#{company.id}")
    end

    it 'updates company attributes' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      patch "/companies?id=#{company.id}", params: company_params

      company.reload

      expect(company.name).to eq('New Name')
      expect(company.friendly_name).to eq('New Friendly Name')
      expect(company.address1).to eq('New Address 1')
      expect(company.address2).to eq('New Address 2')
      expect(company.city).to eq('New City')
      expect(company.state).to eq('New State')
      expect(company.county).to eq('New County')
      expect(company.zip).to eq('New Zip')
      expect(company.country).to eq('New Country')
      expect(company.description).to eq('New Description')
    end

    it 'redirects on invalid company params' do
      patch "/companies?id=#{company.id}", params: { company: { name: '' } }

      expect(response).to redirect_to("/companies?id=#{company.id}")
    end

    it 'renders flash on invalid company params' do
      patch "/companies?id=#{company.id}", params: { company: { name: '' } }

      expect(flash[:alert]).to eq("Name can't be blank")
    end
  end
end
