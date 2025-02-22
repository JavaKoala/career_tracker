require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:interviews).dependent(:destroy) }
  it { is_expected.to have_many(:next_steps).dependent(:destroy) }

  it { is_expected.to have_one_attached(:cover_letter) }

  it { is_expected.to accept_nested_attributes_for(:position) }

  it { is_expected.to validate_presence_of(:source) }

  describe 'delegates' do
    it { expect(described_class.new).to delegate_method(:name).to(:position).with_prefix }
    it { expect(described_class.new).to delegate_method(:description).to(:position).with_prefix }
    it { expect(described_class.new).to delegate_method(:pay_start).to(:position).with_prefix }
    it { expect(described_class.new).to delegate_method(:pay_end).to(:position).with_prefix }
    it { expect(described_class.new).to delegate_method(:location).to(:position).with_prefix }
    it { expect(described_class.new).to delegate_method(:company).to(:position) }
    it { expect(described_class.new).to delegate_method(:name).to(:company).with_prefix }
    it { expect(described_class.new).to delegate_method(:friendly_name).to(:company).with_prefix }
    it { expect(described_class.new).to delegate_method(:description).to(:company).with_prefix }
  end

  it 'sets the applied date to today' do
    job_application = build(:job_application, applied: nil)
    job_application.save!

    expect(job_application.applied).to eq(Date.current)
  end
end
