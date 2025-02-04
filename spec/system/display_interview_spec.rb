require 'rails_helper'

RSpec.describe 'Display Interview', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:job_application) { create(:job_application, user: user) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'displays a interview' do
    interview = create(:interview, job_application: job_application)

    visit job_application_path(job_application)

    click_on "job-application-interview-#{interview.id}"

    expect(page).to have_content(interview.interview_start)
    expect(page).to have_content(interview.interview_end)
    expect(page).to have_content(interview.location)
  end
end
