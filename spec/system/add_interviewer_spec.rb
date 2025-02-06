require 'rails_helper'

RSpec.describe 'Add Interviewer', type: :system do
  let(:interview) { create(:interview) }

  before do
    session = create(:session, user: interview.user)
    allow(Current).to receive_messages(session: session, user: interview.user)
  end

  describe 'Adding an Interviewer' do
    it 'creates a new interviewer' do
      visit interview_path(interview)

      expect(page).to have_no_content('Interviewers')

      click_on 'Add interviewer'

      fill_in('Name', with: 'John Doe')
      fill_in('Email', with: 'jdoe@test.com')

      expect do
        click_on 'Add new'

        expect(page).to have_content('Interviewers')
        expect(page).to have_content('John Doe')
        expect(page).to have_content('jdoe@test.com')
      end.to change(Interviewer, :count).by(1)
    end

    it 'adds an existing person as an interviewer' do
      person = create(:person, company: interview.company)

      visit interview_path(interview)

      expect(page).to have_no_content('Interviewers')

      click_on 'Add interviewer'

      select(person.name, from: 'Interviewer')

      expect do
        click_on 'Add existing'

        expect(page).to have_content(person.name)
        expect(page).to have_content(person.email_address)
      end.to change(Interviewer, :count).by(1)
    end

    it 'does not add interviewer when the name is blank' do
      visit interview_path(interview)

      click_on 'Add interviewer'

      fill_in('Name', with: '    ')

      expect do
        click_on 'Add new'

        expect(page).to have_no_content('Interviewers')
        expect(page).to have_content("Person name can't be blank")
      end.not_to change(Interviewer, :count)
    end
  end
end
