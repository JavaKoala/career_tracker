require 'rails_helper'

RSpec.describe 'settings/index.html.erb', type: :view do
  let(:employee) { create(:employee) }

  context 'when the job applications are exporting' do
    let(:user) { instance_double(User, exporting_job_applications: true) }

    before do
      assign(:user, user)
      render
    end

    it { expect(rendered).to match(/#{I18n.t(:export_in_progress)}/) }
    it { expect(rendered).not_to match(/#{I18n.t(:reexport_job_applications)}/) }
    it { expect(rendered).not_to match(/#{I18n.t(:export_job_applications)}/) }
    it { expect(rendered).not_to match(/#{I18n.t(:download_job_applications)}/) }
  end

  context 'when the job applications are not exporting' do
    context 'when the user has an export' do
      let(:user) { create(:user) }
      let(:position) { create(:position) }
      let(:job_application) { create(:job_application, user: user, position: position) }
      let(:export_service) { ExportJobApplications.new(user.id) }

      before do
        export_service.perform
        assign(:user, user)
        render
      end

      it { expect(rendered).not_to match(/#{I18n.t(:export_in_progress)}/) }
      it { expect(rendered).to match(/#{I18n.t(:reexport_job_applications)}/) }
      it { expect(rendered).not_to match(/#{I18n.t(:export_job_applications)}/) }
      it { expect(rendered).to match(/#{I18n.t(:download_job_applications)}/) }
    end

    context 'when the user does not have an export' do
      let(:user) { create(:user) }

      before do
        assign(:user, user)
        render
      end

      it { expect(rendered).not_to match(/#{I18n.t(:export_in_progress)}/) }
      it { expect(rendered).not_to match(/#{I18n.t(:reexport_job_applications)}/) }
      it { expect(rendered).to match(/#{I18n.t(:export_job_applications)}/) }
      it { expect(rendered).not_to match(/#{I18n.t(:download_job_applications)}/) }
    end
  end
end
