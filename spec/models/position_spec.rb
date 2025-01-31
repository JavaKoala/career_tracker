require 'rails_helper'

RSpec.describe Position, type: :model do
  it { is_expected.to belong_to(:company) }
  it { is_expected.to have_many(:job_applications).dependent(:destroy) }

  it { is_expected.to accept_nested_attributes_for(:company) }

  it 'has enum for location' do
    position = described_class.new

    expect(position).to define_enum_for(:location).with_values(office: 0, hybrid: 1,
                                                               remote: 2).backed_by_column_of_type(:integer)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }

  describe '#already_applied?' do
    let(:user) { create(:user) }
    let(:position) { create(:position) }

    it 'returns true if user has already applied' do
      create(:job_application, user: user, position: position)

      expect(position.already_applied?(user)).to be true
    end

    it 'returns false if user has not applied' do
      expect(position.already_applied?(user)).to be false
    end
  end
end
