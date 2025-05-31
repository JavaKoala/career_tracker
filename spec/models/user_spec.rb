require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:sessions).dependent(:destroy) }
  it { is_expected.to have_many(:job_applications).dependent(:destroy) }
  it { is_expected.to have_one_attached(:job_application_export) }
  it { is_expected.to have_one_attached(:job_application_import) }

  it 'normalizes email address' do
    user = described_class.new(email_address: ' FOO@Bar.com ')

    expect(user.email_address).to eq('foo@bar.com')
  end

  describe '#active_applications' do
    let(:user) { create(:user) }
    let(:position) { create(:position) }
    let(:job_application) do
      create(:job_application,
             user: user,
             position: position)
    end

    it 'returns active job applications' do
      create(:job_application,
             active: false,
             position: position,
             user: user)

      expect(job_application.user.active_applications).to eq([job_application])
    end
  end
end
