require 'rails_helper'

RSpec.describe ImportJobApplications do
  let(:user) { create(:user) }
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

    it 'raises an exception if a record is not imported' do
      allow(CSVSafe).to receive(:foreach).and_raise(StandardError.new('CSV parsing error'))

      expect { service.perform }.to raise_error(StandardError, 'CSV parsing error')
    end
  end
end
