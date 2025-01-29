require 'rails_helper'

RSpec.describe CompaniesController, type: :request do
  let(:user) { create(:user) }

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'GET /job_applications/:id' do
    it 'returns a success response' do
      company = create(:company)

      get "/companies?id=#{company.id}"

      expect(response).to be_successful
    end

    it 'redirects on invalid company id' do
      get '/companies?id=0'

      expect(response).to redirect_to root_path
    end
  end
end
