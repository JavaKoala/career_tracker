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
    expect(page).to have_content(job_application.applied)
    expect(page).to have_content(job_application.accepted)
    expect(page).to have_content(job_application.position_name)
    expect(page).to have_content(job_application.position_description.body.to_plain_text)
    expect(page).to have_content(job_application.position_pay_start)
    expect(page).to have_content(job_application.position_pay_end)
    expect(page).to have_content(job_application.company_name)
    expect(page).to have_content(job_application.company_friendly_name)
    expect(page).to have_content(job_application.company_description)
  end

  it 'displays all job applications' do
    job_application = create(:job_application, user: user, active: false)

    visit root_path

    expect(page).to have_no_content(job_application.position.name)

    click_on 'All applications'

    expect(page).to have_content(job_application.position.name)
  end

  it 'does not display job applications from other users' do
    user1 = create(:user, email_address: 'test@test.com')
    job_application = create(:job_application, user: user1)

    visit root_path

    expect(page).to have_no_content(job_application.position.name)

    click_on 'All applications'

    expect(page).to have_no_content(job_application.position.name)
  end
end
