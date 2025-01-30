require 'rails_helper'

RSpec.describe 'Display Job Application', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'displays a job application' do
    job_application = create(:job_application, user: user)

    visit root_path

    click_on job_application.position.name

    expect(page).to have_content(job_application.source)
    expect(page).to have_content(job_application.position_name)
    expect(page).to have_content(job_application.position_description)
    expect(page).to have_content(job_application.position_pay_start)
    expect(page).to have_content(job_application.position_pay_end)
    expect(page).to have_content(job_application.company_name)
    expect(page).to have_content(job_application.company_friendly_name)
    expect(page).to have_content(job_application.company_description)
  end
end
