require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to accept_nested_attributes_for(:position) }

  it 'sets the applied date to today' do
    job_application = build(:job_application, applied: nil)
    job_application.save!

    expect(job_application.applied).to eq(Date.current)
  end
end
