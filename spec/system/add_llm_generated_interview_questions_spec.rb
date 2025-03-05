require 'rails_helper'

RSpec.describe 'Add Llm Generated Interview Questions', type: :system do
  let(:job_application) { create(:job_application) }
  let(:interview) { create(:interview, job_application: job_application) }

  before do
    ActiveJob::Base.queue_adapter = :test
    session = create(:session, user: job_application.user)
    allow(Current).to receive_messages(session: session, user: job_application.user)
  end

  describe 'Adding interview questions' do
    it 'enqueues a job for the llm to create the interview questions' do
      visit interview_path(interview)

      click_on 'Generate interview questions with AI'

      expect(page).to have_content('Creating interview questions')
      expect(CreateLlmInterviewQuestionsJob).to have_been_enqueued.with(interview.id, '0.5')
    end
  end
end
