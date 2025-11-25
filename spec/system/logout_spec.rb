require 'rails_helper'

RSpec.describe 'Logout', type: :system do
  it 'logs the user out' do
    user = create(:user, password: 'qoKryj-vitwoj-towca9')

    visit '/session/new'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'qoKryj-vitwoj-towca9'

    click_on 'Sign in'

    expect(page).to have_content('Career Tracker')
    expect(page).to have_content('Sign out')

    click_on 'Sign out'

    expect(page).to have_content('Sign in')

    visit root_path

    expect(page).to have_content('Sign in')
  end
end
