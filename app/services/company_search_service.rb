class CompanySearchService
  def initialize(params)
    @params = params
  end

  def search
    if @params[:name].present?
      Company.where('name LIKE ?', "%#{@params[:name]}%").order(name: direction)
    else
      Company.order(name: direction)
    end
  end

  def direction
    %w[asc desc].include?(@params[:direction]) ? @params[:direction] : 'asc'
  end
end
