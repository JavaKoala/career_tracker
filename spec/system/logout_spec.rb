require 'rails_helper'

RSpec.describe 'Logout', type: :system do
  it 'logs the use out' do
    user = create(:user)

    visit '/session/new'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'password'

    click_on 'Sign in'

    expect(page).to have_content('Sign out')

    click_on 'Sign out'

    Capybara.refresh
    Capybara.refresh

    expect(page).to have_content('Sign in')

    visit root_path

    expect(page).to have_content('Sign in')
  end
end
