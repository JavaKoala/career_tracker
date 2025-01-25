require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to accept_nested_attributes_for(:position) }
  it { is_expected.to accept_nested_attributes_for(:user) }
end
