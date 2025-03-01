require 'rails_helper'

RSpec.describe CompanySearchService do
  describe '#search' do
    context 'when the search is present' do
      it 'returns companies with the name' do
        company = create(:company, name: 'Test Company')
        create(:company, name: 'Another Company')

        company_search_service = described_class.new(search: 'Test')

        expect(company_search_service.search).to eq([company])
      end
    end

    context 'when the name is not present' do
      it 'returns all companies' do
        create(:company, name: 'Test Company')
        create(:company, name: 'Another Company')

        company_search_service = described_class.new({})

        expect(company_search_service.search.count).to eq(2)
      end
    end
  end

  describe '#direction' do
    context 'when the direction is asc' do
      it 'returns asc' do
        company_search_service = described_class.new(direction: 'asc')

        expect(company_search_service.direction).to eq('asc')
      end
    end

    context 'when the direction is desc' do
      it 'returns desc' do
        company_search_service = described_class.new(direction: 'desc')

        expect(company_search_service.direction).to eq('desc')
      end
    end

    context 'when the direction is not asc or desc' do
      it 'returns asc' do
        company_search_service = described_class.new({})

        expect(company_search_service.direction).to eq('asc')
      end
    end
  end
end
