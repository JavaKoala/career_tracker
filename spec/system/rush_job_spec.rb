require 'rails_helper'

RSpec.describe 'Rush Job', type: :system do
  it 'only displays delayed jobs when logged in' do
    user = create(:user)

    visit '/rush_job'

    expect(page).to have_no_content('Delayed Jobs')

    visit '/session/new'

    fill_in 'Enter your email address', with: user.email_address
    fill_in 'Enter your password', with: 'password'

    click_on 'Sign in'

    expect(page).to have_content('Active applications')

    visit '/rush_job'

    expect(page).to have_content('Delayed Jobs')
  end
end
