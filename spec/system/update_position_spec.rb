require 'rails_helper'

RSpec.describe 'Update Position', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:position) { create(:position) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'updates a position' do
    visit position_path(position)

    click_on 'Update position'

    fill_in 'Position name', with: 'New Name'
    fill_in 'Description', with: 'New Description'
    fill_in 'Pay start', with: '200000'
    fill_in 'Pay end', with: '250000'

    click_on 'Update'

    expect(page).to have_content('Updated position')
    expect(page).to have_content('New Name')
    expect(page).to have_content('New Description')
    expect(page).to have_content('200000')
    expect(page).to have_content('250000')
  end

  it 'renders flash on invalid position name' do
    visit position_path(position)

    click_on 'Update position'

    fill_in 'Position name', with: '     '

    click_on 'Update'

    expect(page).to have_content("Name can't be blank")
  end
end
