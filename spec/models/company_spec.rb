require 'rails_helper'

RSpec.describe Company, type: :model do
  it { is_expected.to have_many(:positions).dependent(:destroy) }
  it { is_expected.to have_many(:people).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
end
