require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:sessions).dependent(:destroy) }
  it { is_expected.to have_many(:job_applications).dependent(:destroy) }
  it { is_expected.to have_one_attached(:job_application_export) }
  it { is_expected.to have_one_attached(:job_application_import) }

  it 'normalizes email address' do
    user = described_class.new(email_address: ' FOO@Bar.com ')

    expect(user.email_address).to eq('foo@bar.com')
  end

  describe '#correct_job_application_import_mime_type' do
    let(:user) { create(:user) }
    let(:job_applications_file) { fixture_file_upload('spec/fixtures/job_applications_upload.csv', 'text/csv') }
    let(:invalid_file) { fixture_file_upload('spec/fixtures/cover_letter.txt', 'text/plain') }

    context 'when the file is not attached' do
      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'when the file is attached' do
      it 'is valid with correct mime type' do
        user.job_application_import.attach(job_applications_file)

        expect(user).to be_valid
      end

      it 'is invalid with incorrect mime type' do
        user.job_application_import.attach(invalid_file)

        expect(user).not_to be_valid
      end

      it 'adds an error message for incorrect mime type' do
        user.job_application_import.attach(invalid_file)

        expect(user.errors[:job_application_import]).to include('must be a CSV file')
      end
    end
  end

  describe '#active_applications' do
    let(:user) { create(:user) }
    let(:position) { create(:position) }
    let(:job_application) do
      create(:job_application,
             user: user,
             position: position)
    end

    it 'returns active job applications' do
      create(:job_application,
             active: false,
             position: position,
             user: user)

      expect(job_application.user.active_applications).to eq([job_application])
    end
  end
end
