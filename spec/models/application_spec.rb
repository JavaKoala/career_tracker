require 'rails_helper'

RSpec.describe Application, type: :model do
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:user) }
end
