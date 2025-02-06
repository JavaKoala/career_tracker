require 'rails_helper'

RSpec.describe Interviewer, type: :model do
  it { is_expected.to belong_to(:interview) }
  it { is_expected.to belong_to(:person) }

  it { is_expected.to accept_nested_attributes_for(:person) }
end
