require 'rails_helper'

RSpec.describe HomeCalendarInterviewService do
  before do
    allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
    allow(Rails.configuration.home_calendar).to receive(:[]).with(:url).and_return('http://localhost:3001/api/v1')
    allow(Rails.configuration.home_calendar).to receive(:[]).with(:color).and_return('#000000')
    allow(Faraday).to receive(:new).and_return(faraday_connection)
  end

  describe '#create_event' do
    let(:interview) { create(:interview) }
    let(:service) { described_class.new }
    let(:home_calendar_post_response) do
      [{ id: 1, title: 'test title', start: Time.zone.now, end: Time.zone.now, color: 'blue', recurring_uuid: 'test' }]
    end
    let(:faraday_post_response) { instance_double(Faraday::Response, body: home_calendar_post_response.to_json) }
    let(:faraday_connection) { instance_double(Faraday::Connection, post: faraday_post_response) }

    context 'when the interview is found' do
      it 'creates a new event' do
        service.create_event(interview.id)

        expect(faraday_connection).to have_received(:post).with(
          '/api/v1/events',
          service.instance_variable_get(:@home_calendar_event).to_json
        )
      end

      it 'updates the interview home calendar event id' do
        service.create_event(interview.id)

        expect(interview.reload.home_calendar_event_id).to eq(1)
      end
    end

    context 'when the api event is invalid' do
      it 'does not update the interview home calendar event id' do
        allow(JSON).to receive(:parse).and_return([{ id: nil }])

        service.create_event(interview.id)

        expect(interview.reload.home_calendar_event_id).to be_nil
      end
    end

    context 'when the interview is not found' do
      it 'does not create a new event' do
        service.create_event(0)

        expect(faraday_connection).not_to have_received(:post)
      end
    end

    context 'when the interview already has a home calendar event id' do
      it 'does not create a new event' do
        interview.update(home_calendar_event_id: 1)

        service.create_event(interview.id)

        expect(faraday_connection).not_to have_received(:post)
      end
    end

    context 'when the home calendar event is invalid' do
      it 'does not create a new event' do
        interview.update_attribute(:interview_start, nil) # rubocop:disable Rails/SkipsModelValidations

        service.create_event(interview.id)

        expect(faraday_connection).not_to have_received(:post)
      end
    end

    context 'when the home calendar is disabled' do
      it 'does not create a new event' do
        allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(false)

        service.create_event(interview.id)

        expect(faraday_connection).not_to have_received(:post)
      end
    end
  end

  describe '#delete_event' do
    let(:faraday_connection) { instance_double(Faraday::Connection, delete: true) }

    context 'when the faraday connection is present' do
      it 'deletes the event' do
        described_class.new.delete_event(1)

        expect(faraday_connection).to have_received(:delete).with('/api/v1/events/1')
      end
    end

    context 'when the faraday connection is not present' do
      it 'does not delete the event' do
        allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(false)

        described_class.new.delete_event(1)

        expect(faraday_connection).not_to have_received(:delete)
      end
    end

    context 'when the event is not found' do
      it 'logs the error' do
        allow(faraday_connection).to receive(:delete).and_raise(Faraday::ResourceNotFound)
        allow(Rails.logger).to receive(:info)

        described_class.new.delete_event(1)

        expect(Rails.logger).to have_received(:info).with('Event not found for id: 1')
      end
    end
  end
end
