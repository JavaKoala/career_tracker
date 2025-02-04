require 'rails_helper'

RSpec.describe 'Add Interview', type: :system do
  let(:job_application) { create(:job_application) }

  before do
    session = create(:session, user: job_application.user)
    allow(Current).to receive_messages(session: session, user: job_application.user)
  end

  describe 'Adding an Interview' do
    it 'creates a new interview' do
      visit job_application_path(job_application)

      expect(page).to have_no_content('Interviews')

      click_on 'Add interview'

      fill_in('Location', with: 'Zoom')
      fill_in('Interview start', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t02:00PM")
      fill_in('Interview end', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t04:00PM")

      expect do
        click_on 'Add'

        expect(page).to have_content('Interviews')
        expect(page).to have_content('Zoom')
      end.to change(Interview, :count).by(1)
    end

    it 'does not add interview when end before start' do
      visit job_application_path(job_application)

      click_on 'Add interview'

      fill_in('Location', with: 'Zoom')
      fill_in('Interview start', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t04:00PM")
      fill_in('Interview end', with: "#{Time.zone.today.strftime('%m/%d/%Y')}\t02:00PM")

      expect do
        click_on 'Add'

        expect(page).to have_content("Interview end can't be before start")
      end.not_to change(Interview, :count)
    end
  end
end
