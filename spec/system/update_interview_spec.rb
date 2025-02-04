require 'rails_helper'

RSpec.describe 'Update Interview', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview) { create(:interview, job_application: job_application) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'updates a interview' do
    visit interview_path(interview)

    click_on 'Update interview'

    fill_in('Location', with: 'Zoom')
    fill_in('Interview start', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t02:00PM")
    fill_in('Interview end', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t04:00PM")

    click_on 'Update'

    expect(page).to have_content('Updated interview')
    expect(page).to have_content('Zoom')
  end

  it 'renders flash on invalid interview' do
    visit interview_path(interview)

    click_on 'Update interview'

    fill_in 'Location', with: '     '

    click_on 'Update'

    expect(page).to have_content("Location can't be blank")
  end
end
