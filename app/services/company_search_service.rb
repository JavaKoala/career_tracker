class CompanySearchService
  def initialize(params)
    @params = params
  end

  def search
    if @params[:name].present?
      Company.where('name LIKE ?', "%#{@params[:name]}%")
    else
      Company.all
    end
  end
end
