require 'rails_helper'

RSpec.describe Search::SearchService do
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
