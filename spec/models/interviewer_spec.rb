require 'rails_helper'

RSpec.describe Interviewer, type: :model do
  it { is_expected.to belong_to(:interview) }
  it { is_expected.to belong_to(:person) }
end
