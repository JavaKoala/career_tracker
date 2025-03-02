module Search
  class JobApplicationSearch < SearchService
    def initialize(params, user)
      super(params)
      @user = user
    end

    def search
      if @params[:search].present?
        job_application_search
      else
        JobApplication.where(user_id: @user.id)
      end
    end

    private

    def job_application_search
      JobApplication.joins(position: :company)
                    .where(
                      'job_applications.user_id = ? AND (positions.name LIKE ? OR companies.name LIKE ?)',
                      @user.id,
                      "%#{Position.sanitize_sql_like(@params[:search])}%",
                      "%#{Company.sanitize_sql_like(@params[:search])}%"
                    )
    end
  end
end
