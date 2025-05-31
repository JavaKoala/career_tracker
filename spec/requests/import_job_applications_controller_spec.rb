require 'rails_helper'

RSpec.describe ImportJobApplicationsController, type: :request do
  describe 'PATCH /import_job_applications/:id' do
    let(:file) { fixture_file_upload('spec/fixtures/job_applications_upload.csv', 'text/csv') }

    context 'when the update is successful' do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }

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
      let(:error) do
        instance_double(ActiveModel::Errors, full_messages: ['invalid file'])
      end
      let(:user) do
        instance_double(User, update: false,
                              errors: error)
      end
      let(:session) { instance_double(Session, user: user) }

      before do
        allow(Current).to receive_messages(session: session, user: user)
      end

      it 'redirects to settings' do
        patch '/import_job_applications/create', params: { user: { job_application_import: file } }

        expect(response).to redirect_to(settings_path)
      end

      it 'renders an alert with error messages' do
        patch '/import_job_applications/create', params: { user: { job_application_import: file } }

        expect(flash[:alert]).to eq('invalid file')
      end
    end
  end
end
