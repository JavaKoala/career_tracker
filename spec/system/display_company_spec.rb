require 'rails_helper'

RSpec.describe 'Display Company', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:company) { create(:company) }
  let(:position) { create(:position, company: company) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'displays a company' do
    job_application = create(:job_application, position: position, user: user)

    visit root_path

    click_on job_application.company_name

    expect(page).to have_content(company.name)
    expect(page).to have_content(company.friendly_name)
    expect(page).to have_content(company.address1)
    expect(page).to have_content(company.address2)
    expect(page).to have_content(company.city)
    expect(page).to have_content(company.state)
    expect(page).to have_content(company.county)
    expect(page).to have_content(company.zip)
    expect(page).to have_content(company.country)
    expect(page).to have_content(company.description)
  end
end
