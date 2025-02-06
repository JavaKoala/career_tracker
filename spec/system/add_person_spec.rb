require 'rails_helper'

RSpec.describe 'Add Person', type: :system do
  let(:company) { create(:company) }

  before do
    user = create(:user)
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'Adding a person' do
    it 'creates a new person' do
      visit company_path(company)

      expect(page).to have_no_content('People')

      click_on 'Add person'

      fill_in 'Name', with: 'John Doe'
      fill_in 'Email', with: 'jdoe@test.com'

      expect do
        click_on 'Add'

        expect(page).to have_content('People')
        expect(page).to have_content('John Doe')
        expect(page).to have_content('jdoe@test.com')
      end.to change(Person, :count).by(1)
    end

    it 'does not add person with a blank name' do
      visit company_path(company)

      click_on 'Add person'

      fill_in 'Name', with: '    '
      fill_in 'Email', with: 'jdoe@test.com'

      expect do
        click_on 'Add'

        expect(page).to have_no_content('People')
        expect(page).to have_content("Name can't be blank")
      end.not_to change(Person, :count)
    end
  end
end
