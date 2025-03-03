require 'rails_helper'

RSpec.describe 'Add Llm Generated Cover Letter', type: :system do
  let(:job_application) { create(:job_application) }

  before do
    ActiveJob::Base.queue_adapter = :test
    session = create(:session, user: job_application.user)
    allow(Current).to receive_messages(session: session, user: job_application.user)
  end

  describe 'Adding a cover letter' do
    it 'enqueues a job for the llm to create the cover letter' do
      visit job_application_path(job_application)

      click_on 'Generate cover letter with AI'

      expect(page).to have_content('Creating cover letter')
      expect(CreateLlmCoverLetterJob).to have_been_enqueued.with(job_application.id, '0.5')
    end
  end
end
