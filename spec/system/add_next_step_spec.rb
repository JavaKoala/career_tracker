require 'rails_helper'

RSpec.describe 'Add Next Step', type: :system do
  let(:job_application) { create(:job_application) }
  let(:interview) { create(:interview, job_application: job_application) }

  before do
    session = create(:session, user: job_application.user)
    allow(Current).to receive_messages(session: session, user: job_application.user)
  end

  describe 'Adding a Next Step Through Interview' do
    it 'creates a new next step' do
      visit interview_path(interview)

      expect(page).to have_no_content('Next Steps')

      click_on 'Add next step'

      fill_in('Description', with: '    ')
      fill_in('Due', with: "#{1.day.ago.strftime('%m/%d/%Y')}\t02:00PM")

      expect do
        click_on 'Add'

        expect(page).to have_content("Description can't be blank")
      end.not_to change(NextStep, :count)

      click_on 'Add next step'

      fill_in('Description', with: 'Send follow-up email')
      fill_in('Due', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t02:00PM")

      expect do
        click_on 'Add'

        expect(page).to have_content('Next steps')
        expect(page).to have_content('Send follow-up email')
        expect(page).to have_no_content("Description can't be blank")
        expect(page).to have_no_link('App')
      end.to change(NextStep, :count).by(1)
    end
  end

  describe 'Adding a Next Step Through Job Application' do
    it 'creates a new next step' do
      visit job_application_path(job_application)

      expect(page).to have_no_content('Next Steps')

      click_on 'Add next step'

      fill_in('Description', with: 'Send follow-up email')
      fill_in('Due', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t02:00PM")

      expect do
        click_on 'Add'

        expect(page).to have_content('Next steps')
        expect(page).to have_content('Send follow-up email')
        expect(page).to have_content('Steps due today: 1')
      end.to change(NextStep, :count).by(1)
    end
  end
end
