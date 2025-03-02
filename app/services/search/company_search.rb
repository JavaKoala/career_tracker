module Search
  class CompanySearch < SearchService
    def search
      if @params[:search].present?
        Company.where('name LIKE ?', "%#{Company.sanitize_sql_like(@params[:search])}%").order(name: direction)
      else
        Company.order(name: direction)
      end
    end
  end
end
