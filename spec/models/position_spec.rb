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
end
