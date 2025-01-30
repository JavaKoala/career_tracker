require 'rails_helper'

RSpec.describe 'Add Position', type: :system do
  let(:company) { create(:company) }

  before do
    user = create(:user)
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'Adding a position' do
    it 'creates a new position' do
      visit company_path(company)

      click_on 'New position'

      fill_in 'Position name', with: 'Doctor'
      fill_in 'Description', with: 'Heals people'
      fill_in 'Pay start', with: '123000'
      fill_in 'Pay end', with: '150000'
      choose(option: 'hybrid')

      expect do
        click_on 'Add position'

        expect(page).to have_content('Created position')
        expect(page).to have_content('Doctor')
      end.to change(Position, :count).by(1)

      click_on company.name

      expect(page).to have_content('Doctor')
    end

    it 'does not add company with blank name' do
      #       visit company_index_path
      #
      #       click_on 'New company'
      #
      #       fill_in 'Company name', with: '    '
      #
      #       click_on 'Add company'
      #
      #       expect(page).to have_content("Name can't be blank")
      #       expect(page).to have_no_content('Acme')
    end
  end
end
