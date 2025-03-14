require 'rails_helper'

RSpec.describe NextStep, type: :model do
  it { is_expected.to belong_to(:job_application) }

  it { is_expected.to validate_presence_of(:description) }

  it { expect(described_class.new).to delegate_method(:user).to(:job_application) }

  describe '.due_today' do
    let(:user) { create(:user) }

    it 'returns next steps due today' do
      job_application = create(:job_application, user: user)
      next_step = create(:next_step, job_application: job_application, due: Time.zone.now, done: false)

      expect(described_class.due_today(user)).to eq([next_step])
    end

    it 'does not return next steps that are not due today' do
      job_application = create(:job_application, user: user)
      create(:next_step, job_application: job_application, due: Date.current + 1.day, done: false)

      expect(described_class.due_today(user)).to be_empty
    end

    it 'does not return next steps that are done' do
      job_application = create(:job_application, user: user)
      create(:next_step, job_application: job_application, due: Time.zone.now, done: true)

      expect(described_class.due_today(user)).to be_empty
    end

    it 'does not return next steps for inactive job applications' do
      job_application = create(:job_application, user: user, active: false)
      create(:next_step, job_application: job_application, due: Time.zone.now, done: false)

      expect(described_class.due_today(user)).to be_empty
    end
  end

  describe '.past_due' do
    let(:user) { create(:user) }

    it 'returns past due next steps' do
      job_application = create(:job_application, user: user)
      next_step = create(:next_step, job_application: job_application, due: 2.days.ago, done: false)

      expect(described_class.past_due(user)).to eq([next_step])
    end

    it 'does not return next steps that are not past due' do
      job_application = create(:job_application, user: user)
      create(:next_step, job_application: job_application, due: Date.current + 1.day, done: false)

      expect(described_class.past_due(user)).to be_empty
    end

    it 'does not return next steps that are done' do
      job_application = create(:job_application, user: user)
      create(:next_step, job_application: job_application, due: 2.days.ago, done: true)

      expect(described_class.past_due(user)).to be_empty
    end

    it 'does not return next steps for inactive job applications' do
      job_application = create(:job_application, user: user, active: false)
      create(:next_step, job_application: job_application, due: 2.days.ago, done: false)

      expect(described_class.past_due(user)).to be_empty
    end
  end
end
