require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:sessions).dependent(:destroy) }
  it { is_expected.to have_many(:applications).dependent(:destroy) }

  it 'normalizes email address' do
    user = described_class.new(email_address: ' FOO@Bar.com ')

    expect(user.email_address).to eq('foo@bar.com')
  end
end
