require 'rails_helper'

RSpec.describe 'Display Next Steps', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:next_step) { create(:next_step, job_application: job_application) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  context 'when there are next steps' do
    it 'displays next steps' do
      next_step
      visit root_path

      click_on 'Next steps'

      expect(page).to have_content(next_step.description)
      expect(page).to have_no_content('>')
    end

    it 'has link to job application' do
      next_step
      visit next_steps_path

      click_on 'App'

      expect(page).to have_content(job_application.position_name)
    end

    it 'paginates next steps' do
      20.times do |n|
        create(:next_step, description: "Next Step #{n}", job_application: job_application)
      end

      visit next_steps_path

      expect(page).to have_content('Next Step 0')
      expect(page).to have_no_content('Next Step 19')

      click_on '>'

      expect(page).to have_no_content('Next Step 0')
      expect(page).to have_content('Next Step 19')
    end
  end

  context 'when there are no next steps' do
    it 'displays no next steps' do
      visit root_path

      expect(page).to have_no_content('Next steps')

      visit next_steps_path

      expect(page).to have_content('No next steps')
      expect(page).to have_no_content('>')

      click_on 'Home'
    end
  end
end
