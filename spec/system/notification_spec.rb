require 'rails_helper'

RSpec.describe 'Notification', type: :system do
  let(:job_application) { create(:job_application) }
  let(:session) { create(:session, user: job_application.user) }

  before do
    allow(Current).to receive_messages(session: session, user: job_application.user)
  end

  it 'displays next step counts' do
    create(:next_step, job_application: job_application, due: Date.current + 1.day, done: false)
    create(:next_step, job_application: job_application, due: Time.zone.now, done: false)
    create(:next_step, job_application: job_application, due: 2.days.ago, done: false)
    create(:next_step, job_application: job_application, due: 3.days.ago, done: false)

    visit root_path

    expect(page).to have_content('Past due steps: 2')
    expect(page).to have_content('Steps due today: 1')
  end

  it 'does not display next due steps when there are none' do
    create(:next_step, job_application: job_application, due: Date.current + 1.day, done: false)
    create(:next_step, job_application: job_application, due: 3.days.ago, done: true)

    visit root_path

    expect(page).to have_no_content('Past due steps:')
    expect(page).to have_no_content('Steps due today:')
  end
end
