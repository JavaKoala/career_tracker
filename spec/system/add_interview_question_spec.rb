require 'rails_helper'

RSpec.describe 'Add Interview Question', type: :system do
  let(:interview) { create(:interview) }

  before do
    session = create(:session, user: interview.user)
    allow(Current).to receive_messages(session: session, user: interview.user)
  end

  describe 'Adding an Interview Question' do
    it 'creates a new interview question' do
      visit interview_path(interview)

      expect(page).to have_no_content('Interview questions')

      click_on 'Add question'

      fill_in('Question', with: 'I can haz question?')
      fill_in('Answer', with: 'Yes, you can haz!')

      expect do
        click_on 'Add'

        expect(page).to have_content('I can haz question?')
        expect(page).to have_content('Yes, you can haz!')
      end.to change(InterviewQuestion, :count).by(1)
    end

    it 'does not add interview question when question is blank' do
      visit interview_path(interview)

      click_on 'Add question'

      fill_in('Question', with: '    ')

      expect do
        click_on 'Add'

        expect(page).to have_content("Question can't be blank")
      end.not_to change(InterviewQuestion, :count)
    end
  end
end
