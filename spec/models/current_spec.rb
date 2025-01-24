require 'rails_helper'

RSpec.describe Current do
  it 'delegates user to session' do
    session = instance_double(Session, user: User.new)
    allow(described_class).to receive(:session).and_return(session)

    expect(described_class.session.user).to eq(session.user)
  end

  it 'defaults session to nil' do
    expect(described_class.session).to be_nil
  end
end
