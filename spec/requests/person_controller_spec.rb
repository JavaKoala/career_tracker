require 'rails_helper'

RSpec.describe PersonController, type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let(:valid_attributes) do
    {
      person: {
        name: 'John Doe',
        email_address: 'jdoe@test.com',
        company_id: company.id
      }
    }
  end

  before do
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'POST /person' do
    context 'when the company does not exist' do
      it 'redirects to the root path' do
        valid_attributes[:person][:company_id] = 0

        post person_index_path, params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'renders flash message' do
        valid_attributes[:person][:company_id] = 0

        post person_index_path, params: valid_attributes

        expect(flash[:alert]).to eq(I18n.t(:company_not_found))
      end
    end

    context 'with valid parameters' do
      it 'creates a new person' do
        expect do
          post person_index_path, params: valid_attributes
        end.to change(Person, :count).by(1)
      end

      it 'redirects to the company path' do
        post person_index_path, params: valid_attributes

        expect(response).to redirect_to(company_path(company))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          person: {
            name: '    ',
            email_address: 'jdoe@test.com',
            company_id: company.id
          }
        }
      end

      it 'does not create a new person' do
        expect do
          post person_index_path, params: invalid_attributes
        end.not_to change(Person, :count)
      end

      it 'redirects to the company path' do
        post person_index_path, params: invalid_attributes

        expect(response).to redirect_to(company_path(company))
      end

      it 'renders flash message' do
        post person_index_path, params: invalid_attributes

        expect(flash[:alert]).to eq("Name can't be blank")
      end
    end
  end

  describe 'PATCH /person/:id' do
    let(:person) { create(:person, company: company) }

    context 'with invalid person id' do
      it 'redirects to root_path' do
        patch '/person/0', params: valid_attributes

        expect(response).to redirect_to(root_path)
      end

      it 'renders flash message' do
        patch '/person/0', params: valid_attributes

        expect(flash[:alert]).to eq(I18n.t(:person_not_found))
      end
    end

    context 'with valid parameters' do
      it 'updates the person' do
        patch person_path(person), params: { person: { name: 'Jane Doe', company_id: company.id } }

        person.reload

        expect(person.name).to eq('Jane Doe')
      end

      it 'redirects to the company path' do
        patch person_path(person), params: valid_attributes

        expect(response).to redirect_to(company_path(company))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the person' do
        patch person_path(person), params: { person: { name: '    ', company_id: company.id } }

        person.reload

        expect(person.name).not_to eq('')
      end

      it 'redirects to the company path' do
        patch person_path(person), params: { person: { name: '    ', company_id: company.id } }

        expect(response).to redirect_to(company_path(company))
      end

      it 'renders flash message' do
        patch person_path(person), params: { person: { name: '    ', company_id: company.id } }

        expect(flash[:alert]).to eq("Name can't be blank")
      end
    end
  end
end
