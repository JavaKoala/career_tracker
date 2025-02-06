require 'rails_helper'

RSpec.describe 'Delete Interviewer', type: :system do
  let(:interview) { create(:interview) }
  let(:person) { create(:person, company: interview.company) }
  let(:session) { create(:session, user: interview.user) }

  before do
    allow(Current).to receive_messages(session: session, user: interview.user)
  end

  it 'deletes a interview' do
    interviewer = create(:interviewer, interview: interview, person: person)
    visit interview_path(interview)

    click_on "interviewer-#{interviewer.id}-delete"

    expect do
      click_on 'Delete interviewer'
      expect(page).to have_content('Deleted interviewer')
      expect(page).to have_no_content(interviewer.person.name)
    end.to change(Interviewer, :count).by(-1)
  end
end
