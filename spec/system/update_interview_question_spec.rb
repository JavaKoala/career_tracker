require 'rails_helper'

RSpec.describe 'Update Interview Question', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview) { create(:interview, job_application: job_application) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'updates a interview question' do
    interview_question = create(:interview_question, interview: interview)

    visit interview_path(interview)

    click_on "interview-question-#{interview_question.id}-edit"

    fill_in('Question', with: 'What time is it?')
    fill_in('Answer', with: 'Miller time!')

    click_on 'Update question'

    expect(page).to have_content('What time is it?')
    expect(page).to have_content('Miller time!')
  end

  it 'renders flash on invalid question' do
    interview_question = create(:interview_question, interview: interview)

    visit interview_path(interview)

    click_on "interview-question-#{interview_question.id}-edit"

    fill_in 'Question', with: '     '

    click_on 'Update question'

    expect(page).to have_content("Question can't be blank")
  end
end
