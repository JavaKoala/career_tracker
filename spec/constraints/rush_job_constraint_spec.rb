require 'rails_helper'

RSpec.describe RushJobConstraint do
  let(:request) { instance_double(ActionDispatch::Request) }

  before do
    allow(request).to receive(:key_generator)
    allow(request).to receive(:signed_cookie_salt)
    allow(request).to receive(:cookies).and_return({})
  end

  describe '.matches?' do
    it 'returns true when session exists' do
      session = create(:session)

      cookies = instance_double(ActionDispatch::Cookies::CookieJar, signed: { session_id: session.id })
      allow(ActionDispatch::Cookies::CookieJar).to receive(:build).and_return(cookies)

      expect(described_class.matches?(request)).to be(true)
    end

    it 'returns false when session does not exist' do
      cookies = instance_double(ActionDispatch::Cookies::CookieJar, signed: { session_id: 1 })
      allow(ActionDispatch::Cookies::CookieJar).to receive(:build).and_return(cookies)

      expect(described_class.matches?(request)).to be(false)
    end

    it 'returns false when no session id' do
      cookies = instance_double(ActionDispatch::Cookies::CookieJar, signed: {})
      allow(ActionDispatch::Cookies::CookieJar).to receive(:build).and_return(cookies)

      expect(described_class.matches?(request)).to be(false)
    end
  end
end
