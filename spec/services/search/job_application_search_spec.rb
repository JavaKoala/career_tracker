require 'rails_helper'

RSpec.describe Search::JobApplicationSearch do
  describe '#search' do
    let(:user) { create(:user) }
    let(:company) { create(:company, name: 'Test Company') }
    let(:position) { create(:position, name: 'Test Position', company: company) }

    before do
      user1 = create(:user, email_address: 'user@test.com')
      create(:job_application, position: position, user: user)
      create(:job_application, position: position, user: user1)
    end

    context 'when the search is present' do
      it 'only returns job applications for the given user' do
        job_application_search_service = described_class.new({ search: 'Test' }, user)

        expect(job_application_search_service.search.first.user).to eq(user)
      end

      it 'returns job applications with the position name' do
        job_application_search_service = described_class.new({ search: 'Test Position' }, user)

        expect(job_application_search_service.search.first.position).to eq(position)
      end

      it 'returns job applications with the company name' do
        job_application_search_service = described_class.new({ search: 'Test Company' }, user)

        expect(job_application_search_service.search.first.position.company).to eq(company)
      end
    end

    context 'when the name is not present' do
      it 'returns all companies for the given user' do
        job_application_search_service = described_class.new({}, user)

        expect(job_application_search_service.search.count).to eq(1)
      end

      it 'returns companies for the given user' do
        job_application_search_service = described_class.new({}, user)

        expect(job_application_search_service.search.first.user).to eq(user)
      end
    end
  end
end
