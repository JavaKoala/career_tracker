require 'rails_helper'

RSpec.describe 'Add Company', type: :system do
  before do
    user = create(:user)
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'Adding a company' do
    it 'creates a new company' do
      visit company_index_path

      click_on 'New company'

      fill_in 'Company name', with: 'Acme'

      expect do
        click_on 'Add company'

        expect(page).to have_content('Created company')
        expect(page).to have_content('Acme')
      end.to change(Company, :count).by(1)
    end

    it 'does not add company with blank name' do
      visit company_index_path

      click_on 'New company'

      fill_in 'Company name', with: '    '

      click_on 'Add company'

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_no_content('Acme')
    end
  end
end
