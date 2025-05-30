require 'rails_helper'

RSpec.describe ExportJobApplications do
  let(:user) { create(:user, exporting_job_applications: true) }
  let(:position) { create(:position) }
  let(:job_application) { create(:job_application, user: user, position: position) }
  let(:export_service) { described_class.new(user.id) }

  describe '#perform' do
    it 'attaches the exported file to the user' do
      job_application

      export_service.perform

      expect(user.reload.job_application_export).to be_attached
    end

    it 'sets exporting_job_applications to false' do
      job_application

      export_service.perform

      expect(user.reload.exporting_job_applications).to be false
    end
  end
end
