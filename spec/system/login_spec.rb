require 'rails_helper'

RSpec.describe 'Login', type: :system do
  it 'allows a user to login' do
    user = create(:user)

    visit '/session/new'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'password'

    click_on 'Sign in'

    expect(page).to have_content('Career Tracker')

    visit root_path

    expect(page).to have_content('Career Tracker')
  end

  it 'does not allow a user to login with incorrect password' do
    user = create(:user)

    visit '/session/new'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'wrong'

    click_on 'Sign in'

    expect(page).to have_content('Try another email address or password.')
  end
end
