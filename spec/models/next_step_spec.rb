require 'rails_helper'

RSpec.describe NextStep, type: :model do
  it { is_expected.to belong_to(:job_application) }

  it { is_expected.to validate_presence_of(:description) }

  it { expect(described_class.new).to delegate_method(:user).to(:job_application) }
end
