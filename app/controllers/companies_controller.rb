class CompaniesController < ApplicationController
  def show
    @company = Company.find_by(id: params[:id])

    redirect_to root_path unless @company
  end
end
