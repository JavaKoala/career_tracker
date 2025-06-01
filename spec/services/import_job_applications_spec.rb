require 'rails_helper'

RSpec.describe ImportJobApplications do
  let(:user) { create(:user, importing_job_applications: true) }
  let(:file) { fixture_file_upload('spec/fixtures/job_applications_upload.csv', 'text/csv') }
  let(:service) { described_class.new(user.id) }

  before do
    user.job_application_import.attach(file)
  end

  describe '#perform' do
    it { expect { service.perform }.to change { user.job_applications.count }.by(1) }
    it { expect { service.perform }.to change(Position, :count).by(1) }
    it { expect { service.perform }.to change(Company, :count).by(1) }

    it 'assigns job applicaion attributes' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      service.perform

      job_application = user.job_applications.last
      position = job_application.position
      company = position.company

      expect(job_application.source).to eq('Indeed')
      expect(job_application.active).to be true
      expect(position.name).to eq("'); SET foreign_key_checks = 0; DROP TABLE job_applications; --")
      expect(position.description.to_plain_text).to eq('Deliver Software solutions')
      expect(position.pay_start).to eq(100_000)
      expect(position.pay_end).to eq(120_000)
      expect(position.location).to eq('remote')
      expect(company.name).to eq('Test Company')
      expect(company.description).to eq('Delivering software solutions')
    end

    it 'sets :importing_job_applications to false' do
      service.perform

      expect(user.reload.importing_job_applications).to be false
    end

    context 'when there is an error' do
      before do
        allow(CSVSafe).to receive(:foreach).and_raise(StandardError.new('CSV parsing error'))
      end

      it { expect { service.perform }.to raise_error(StandardError, 'CSV parsing error') }

      it 'keeps :importing_job_applications as true' do
        service.perform
      rescue StandardError
        expect(user.reload.importing_job_applications).to be true
      end

      it 'saves the error message' do
        service.perform
      rescue StandardError
        user.reload
        expect(user.import_error).to eq('CSV parsing error')
      end
    end

    context 'when the user has an import error' do
      before do
        user.update(import_error: 'Previous import error')
      end

      it 'does not perform the import' do
        expect { service.perform }.not_to(change { user.job_applications.count })
      end

      it 'does not change :importing_job_applications' do
        service.perform

        expect(user.reload.importing_job_applications).to be true
      end

      it 'does not clear the import error' do
        service.perform

        expect(user.reload.import_error).to eq('Previous import error')
      end
    end
  end
end
