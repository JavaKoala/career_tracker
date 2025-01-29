require 'rails_helper'

RSpec.describe 'Update Company', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:company) { create(:company) }
  let(:position) { create(:position, company: company) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'updates a company' do
    job_application = create(:job_application, position: position, user: user)

    visit root_path

    click_on job_application.company_name
    click_on 'Update company'

    fill_in 'Company name', with: 'New Name'
    fill_in 'Friendly name', with: 'New Friendly Name'
    fill_in 'Company description', with: 'New Description'
    fill_in 'Address 1', with: 'New Address 1'
    fill_in 'Address 2', with: 'New Address 2'
    fill_in 'City', with: 'New City'
    fill_in 'State', with: 'New State'
    fill_in 'County', with: 'New County'
    fill_in 'Zip', with: 'New Zip'
    fill_in 'Country', with: 'New Country'

    click_on 'Update'

    expect(page).to have_content('Updated company')
    expect(page).to have_content('New Name')
    expect(page).to have_content('New Friendly Name')
    expect(page).to have_content('New Description')
    expect(page).to have_content('New Address 1')
    expect(page).to have_content('New Address 2')
    expect(page).to have_content('New City')
    expect(page).to have_content('New State')
    expect(page).to have_content('New County')
    expect(page).to have_content('New Zip')
    expect(page).to have_content('New Country')
  end

  it 'renders flash on invalid company name' do
    job_application = create(:job_application, position: position, user: user)

    visit root_path

    click_on job_application.company_name
    click_on 'Update company'

    fill_in 'Company name', with: '     '

    click_on 'Update'

    expect(page).to have_content("Name can't be blank")
  end
end
