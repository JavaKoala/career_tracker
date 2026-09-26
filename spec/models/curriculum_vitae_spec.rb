require 'rails_helper'

RSpec.describe CurriculumVitae, type: :model do
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:resume) }

  describe '.resume' do
    let(:resume_json) { file_fixture('resume.json').read }
    let(:cv) { build(:curriculum_vitae) }

    it 'is valid when a valid resume format' do
      cv.resume = resume_json

      expect(cv).to be_valid
    end

    it 'is not valid when not valid when invalid format' do
      cv.resume = 'invalid'

      expect(cv).not_to be_valid
    end
  end
end
