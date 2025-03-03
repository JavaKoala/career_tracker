require 'rails_helper'

RSpec.describe CreateLlmCoverLetterJob do
  describe '.perform_later' do
    it 'enqueues an event' do
      ActiveJob::Base.queue_adapter = :test

      expect do
        described_class.perform_later(1, 0.5)
      end.to have_enqueued_job
    end

    it 'enqueues an event in the default queue' do
      service = instance_double(CoverLetterLlmService, create_cover_letter: true)
      allow(CoverLetterLlmService).to receive(:new).and_return(service)

      described_class.perform_now(1, 0.5)

      expect(service).to have_received(:create_cover_letter)
    end
  end
end
