require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let(:user) { create(:user) }

  before do
    user
  end

  it 'allows a user to login' do
    visit '/session/new'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'password'

    click_on 'Sign in'

    expect(page).to have_content('Active applications')

    visit root_path

    expect(page).to have_content('Active applications')
  end

  it 'does not allow a user to login with incorrect password' do
    visit '/'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'dusqaf-duwbad-6Cyfpo'

    expect do
      click_on 'Sign in'
    end.not_to change(Session, :count)

    expect(page).to have_content('Career Tracker')

    expect(page).to have_no_content('Active applications')
  end
end
