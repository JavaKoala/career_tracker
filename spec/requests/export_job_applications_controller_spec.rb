require 'rails_helper'

RSpec.describe ExportJobApplicationsController, type: :request do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    ActiveJob::Base.queue_adapter = :test
    allow(Current).to receive_messages(session: session, user: user)
  end

  describe 'POST /export_job_applications' do
    it 'enqueues a job to export the job applications' do
      expect do
        post export_job_applications_path
      end.to have_enqueued_job(ExportJobApplicationsJob).with(user.id)
    end

    it 'redirects to the job application' do
      post export_job_applications_path

      expect(response).to redirect_to(settings_path)
    end

    it 'sets a flash message' do
      post export_job_applications_path

      expect(flash[:notice]).to eq('Your job applications are being exported. Check back for the download link.')
    end
  end
end
