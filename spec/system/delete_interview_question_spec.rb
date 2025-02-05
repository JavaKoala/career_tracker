require 'rails_helper'

RSpec.describe 'Delete Interview Question', type: :system do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }
  let(:job_application) { create(:job_application, user: user) }
  let(:interview) { create(:interview, job_application: job_application) }

  before do
    allow(Current).to receive_messages(session: session, user: user)
  end

  it 'deletes a interview' do
    interview_question = create(:interview_question, interview: interview)

    visit interview_path(interview)

    click_on "interview-question-#{interview_question.id}-delete"

    expect do
      click_on 'Delete question'

      expect(page).to have_content('Deleted interview question')
      expect(page).to have_content('Add question')
      expect(page).to have_no_content(interview_question.question)
    end.to change(InterviewQuestion, :count).by(-1)
  end
end
