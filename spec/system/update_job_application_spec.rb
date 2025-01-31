require 'rails_helper'

RSpec.describe 'Update Company', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'changing the active state' do
    it 'changes the active state' do
      job_application = create(:job_application, user: user)

      visit root_path

      click_on job_application.position_name
      uncheck 'job_application_active'

      expect(page).to have_content('Inactive')

      check 'job_application_active'

      expect(page).to have_no_content('Inactive')
      expect(page).to have_content('Active')
    end
  end
end
