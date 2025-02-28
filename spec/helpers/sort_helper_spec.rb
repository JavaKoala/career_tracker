require 'rails_helper'

RSpec.describe SortHelper, type: :helper do
  describe '#sort_direction' do
    it 'returns the default sort direction' do
      expect(sort_direction).to eq('asc')
    end

    it 'returns desc when the params are desc' do
      helper.params[:direction] = 'desc'
      expect(sort_direction).to eq('desc')
    end

    it 'returns desc when the params are asc' do
      helper.params[:direction] = 'asc'
      expect(sort_direction).to eq('asc')
    end
  end

  describe '#change_direction' do
    it 'returns desc when the sort direction is asc' do
      expect(change_direction).to eq('desc')
    end

    it 'returns asc when the sort direction is desc' do
      helper.params[:direction] = 'desc'
      expect(change_direction).to eq('asc')
    end
  end
end
