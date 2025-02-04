require 'rails_helper'

RSpec.describe 'Delete Interview', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview) { create(:interview, job_application: job_application) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'deletes a interview' do
    visit interview_path(interview)

    click_on 'Delete interview'

    expect do
      click_on 'Delete'
      expect(page).to have_content('Deleted interview')
      expect(page).to have_content('Job application')
    end.to change(Interview, :count).by(-1)
  end
end
