require 'rails_helper'

RSpec.describe ImportJobApplicationsJob do
  describe '.perform_later' do
    it 'enqueues an event' do
      ActiveJob::Base.queue_adapter = :test

      expect do
        described_class.perform_later(1)
      end.to have_enqueued_job
    end

    it 'enqueues an event in the default queue' do
      service = instance_double(ImportJobApplications, perform: true)
      allow(ImportJobApplications).to receive(:new).and_return(service)

      described_class.perform_now(1)

      expect(service).to have_received(:perform)
    end
  end
end
