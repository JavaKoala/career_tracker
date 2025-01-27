require 'rails_helper'

RSpec.describe 'Add Job Application', type: :system do
  before do
    user = create(:user)
    session = create(:session, user: user)
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'allows a user to login' do
    visit root_path

    click_on 'New application'

    fill_in 'Job title', with: 'Developer'
    fill_in 'Job description', with: 'A developer role'
    fill_in 'Company name', with: 'Acme'

    expect do
      click_on 'Add application'

      expect(page).to have_no_content('Add application')
    end.to change(JobApplication, :count).by(1)
  end
end
