require 'rails_helper'

RSpec.describe 'Updating a Job Application', type: :system do
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

  describe 'update form' do
    it 'updates a job application' do
      job_application = create(:job_application, user: user)

      visit job_application_path(job_application)

      click_on 'Update Job Application'

      fill_in 'Source', with: 'Career Fair'
      fill_in 'Applied', with: '01/01/2021'
      fill_in 'Accepted', with: '01/02/2021'

      click_on 'Update'

      expect(page).to have_content('Career Fair')
      expect(page).to have_content('2021-01-01')
      expect(page).to have_content('2021-01-02')
    end

    it 'renders flash on invalid source' do
      job_application = create(:job_application, user: user)

      visit job_application_path(job_application)

      click_on 'Update Job Application'

      fill_in 'Source', with: '     '

      click_on 'Update'

      expect(page).to have_content("Source can't be blank")
    end
  end
end
