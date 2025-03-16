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
    end
  end

  context 'when there are no next steps' do
    it 'does not display next step button' do
      visit root_path

      expect(page).to have_no_content('Next steps')
    end
  end
end
