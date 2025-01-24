require 'rails_helper'

RSpec.describe Position, type: :model do
  it { is_expected.to belong_to(:company) }
  it { is_expected.to have_many(:applications).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
end
