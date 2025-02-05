require 'rails_helper'

RSpec.describe InterviewQuestion, type: :model do
  it { is_expected.to belong_to(:interview) }

  it { expect(described_class.new).to delegate_method(:user).to(:interview) }

  it { is_expected.to validate_presence_of(:question) }
end
