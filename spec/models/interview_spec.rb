require 'rails_helper'

RSpec.describe Interview, type: :model do
  it { is_expected.to belong_to(:job_application) }

  it { is_expected.to validate_presence_of(:interview_start) }
  it { is_expected.to validate_presence_of(:interview_end) }
  it { is_expected.to validate_presence_of(:location) }

  it { expect(described_class.new).to delegate_method(:user).to(:job_application).with_prefix }

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
end
