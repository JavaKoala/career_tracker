require 'rails_helper'

RSpec.describe ImportJobApplicationsController, type: :request do
  describe 'PATCH /import_job_applications/:id' do
    context 'when the update is successful' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:file) { fixture_file_upload('spec/fixtures/job_applications_upload.csv', 'text/csv') }

      before do
        allow(Current).to receive_messages(session: session, user: user)
      end

      it 'updates the user with importing_job_applications' do
        patch '/import_job_applications/create', params: { user: { job_application_import: file } }

        expect(user.reload.job_application_import.attached?).to be true
      end

      it 'redirects to settings' do
        patch '/import_job_applications/create', params: { user: { job_application_import: file } }

        expect(response).to redirect_to(settings_path)
      end

      it 'renders a notice with success message' do
        patch '/import_job_applications/create', params: { user: { job_application_import: file } }

        expect(flash[:notice]).to eq(I18n.t(:importing_job_applications))
      end
    end

    context 'when the update is not successful' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:invalid_file) { fixture_file_upload('spec/fixtures/cover_letter.txt', 'text/plain') }

      before do
        allow(Current).to receive_messages(session: session, user: user)
      end

      it 'redirects to settings' do
        patch '/import_job_applications/create', params: { user: { job_application_import: invalid_file } }

        expect(response).to redirect_to(settings_path)
      end

      it 'renders an alert with error messages' do
        patch '/import_job_applications/create', params: { user: { job_application_import: invalid_file } }

        expect(flash[:alert]).to eq('Job application import must be a CSV file')
      end
    end
  end
end
