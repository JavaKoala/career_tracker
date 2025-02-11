require 'rails_helper'

RSpec.describe Interview, type: :model do
  it { is_expected.to belong_to(:job_application) }
  it { is_expected.to have_many(:interview_questions).dependent(:destroy) }
  it { is_expected.to have_many(:interviewers).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:interview_start) }
  it { is_expected.to validate_presence_of(:interview_end) }
  it { is_expected.to validate_presence_of(:location) }

  it { expect(described_class.new).to delegate_method(:user).to(:job_application) }
  it { expect(described_class.new).to delegate_method(:company).to(:job_application) }

  describe '#end_after_start' do
    let(:job_application) { create(:job_application) }

    it 'validates that interview_end is after interview_start' do
      interview = build(:interview, interview_start: 1.day.from_now, interview_end: 1.day.ago,
                                    job_application: job_application)
      interview.validate

      expect(interview).not_to be_valid
    end

    it 'adds error if interview_end is before interview_start' do
      interview = build(:interview, interview_start: 1.day.from_now, interview_end: 1.day.ago,
                                    job_application: job_application)
      interview.validate

      expect(interview.errors[:interview_end]).to include("can't be before start")
    end

    it 'is valid if interview_end is after interview_start' do
      interview = build(:interview, interview_start: 1.day.ago, interview_end: 1.day.from_now,
                                    job_application: job_application)
      interview.validate

      expect(interview).to be_valid
    end
  end

  describe '#create_home_calendar_event' do
    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it 'enqueues a job to create a home calendar event' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
      interview = create(:interview)

      expect do
        interview.run_callbacks(:create) { true }
      end.to have_enqueued_job(CreateHomeCalendarInterviewEventJob).with(interview.id)
    end

    it 'does not enqueue a job if home calendar is disabled' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(false)
      interview = create(:interview)

      expect do
        interview.run_callbacks(:create) { true }
      end.not_to have_enqueued_job(CreateHomeCalendarInterviewEventJob)
    end
  end

  describe '#delete_home_calendar_event' do
    let(:interview) { create(:interview, home_calendar_event_id: 1) }

    before do
      ActiveJob::Base.queue_adapter = :test
    end

    it 'enqueues a job to delete a home calendar event' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
      interview = create(:interview, home_calendar_event_id: 1)

      expect do
        interview.run_callbacks(:destroy) { true }
      end.to have_enqueued_job(DeleteHomeCalendarInterviewEventJob).with(1)
    end

    it 'does not enqueue a job if home calendar is disabled' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(false)
      interview = create(:interview, home_calendar_event_id: 1)

      expect do
        interview.run_callbacks(:destroy) { true }
      end.not_to have_enqueued_job(DeleteHomeCalendarInterviewEventJob)
    end

    it 'does not enqueue a job if home calendar event id is blank' do
      allow(Rails.configuration.home_calendar).to receive(:[]).with(:enabled).and_return(true)
      interview = create(:interview)

      expect do
        interview.run_callbacks(:destroy) { true }
      end.not_to have_enqueued_job(DeleteHomeCalendarInterviewEventJob)
    end
  end
end
