require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to belong_to(:company) }
  it { is_expected.to have_many(:interviewers).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }

  it 'normalizes email address' do
    person = create(:person, email_address: 'fOO@test.COM')

    expect(person.email_address).to eq('foo@test.com')
  end
end
