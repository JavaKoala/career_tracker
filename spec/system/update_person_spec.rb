require 'rails_helper'

RSpec.describe 'Update Person', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:person) { create(:person) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  context 'when updating from a company' do
    it 'updates a person' do
      visit company_path(person.company)

      click_on "person-#{person.id}-edit"

      fill_in('Name', with: 'John Doe')
      fill_in('Email address', with: 'jdoe@test.com')

      click_on "person-#{person.id}-update"

      expect(page).to have_content('John Doe')
      expect(page).to have_content('jdoe@test.com')
    end

    it 'renders flash on invalid person' do
      visit company_path(person.company)

      click_on "person-#{person.id}-edit"

      fill_in 'Name', with: '     '

      click_on "person-#{person.id}-update"

      expect(page).to have_content("Name can't be blank")
    end
  end

  context 'when updating from a interview' do
    let(:job_application) do
      create(:job_application,
             user: user, position: create(:position, company: person.company))
    end
    let(:interview) { create(:interview, job_application: job_application) }

    before do
      create(:interviewer, interview: interview, person: person)
    end

    it 'updates a person' do
      visit interview_path(interview)

      click_on "person-#{person.id}-edit"

      fill_in('Name', with: 'John Doe')
      fill_in('Email address', with: 'jdoe@test.com')

      click_on "person-#{person.id}-update"

      expect(page).to have_content('John Doe')
      expect(page).to have_content('jdoe@test.com')
    end

    it 'renders a flash on invalid person' do
      visit interview_path(interview)

      click_on "person-#{person.id}-edit"

      fill_in 'Name', with: '     '

      click_on "person-#{person.id}-update"

      expect(page).to have_content("Name can't be blank")
    end
  end
end
