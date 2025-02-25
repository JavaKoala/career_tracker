require 'rails_helper'

RSpec.describe 'Update Next Step', type: :system do
  let(:next_step) { create(:next_step) }
  let(:session) { create(:session, user: next_step.user) }

  before do
    allow(Current).to receive_messages(session: session, user: next_step.user)
  end

  describe 'updating a next step' do
    it 'updates a next step' do
      visit job_application_path(next_step.job_application)

      click_on "next-step-#{next_step.id}-edit"
      fill_in('Description', with: '    ')
      click_on 'Update step'

      expect(page).to have_content("Description can't be blank")

      click_on "next-step-#{next_step.id}-edit"
      fill_in('Description', with: 'Updated step description')
      click_on 'Update step'

      expect(page).to have_content('Updated step description')
      expect(page).to have_no_content("Description can't be blank")
    end
  end

  describe 'marking the next step as done' do
    it 'changing the done status of a next step' do
      visit job_application_path(next_step.job_application)

      find_by_id("next-step-#{next_step.id}-done").click_on

      expect(next_step.reload.done).to be(false)

      find_by_id("next-step-#{next_step.id}-done").click_on

      expect(next_step.reload.done).to be(true)
    end
  end
end
