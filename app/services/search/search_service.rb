module Search
  class SearchService
    def initialize(params)
      @params = params
    end

    def direction
      %w[asc desc].include?(@params[:direction]) ? @params[:direction] : 'asc'
    end
  end
end
