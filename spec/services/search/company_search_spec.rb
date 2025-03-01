require 'rails_helper'

RSpec.describe Search::CompanySearch do
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
end
