class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update]

  def show
    redirect_to root_path, alert: t(:company_not_found) unless @company
  end

  def update
    if @company.blank?
      redirect_to root_path, alert: t(:company_not_found)
    elsif @company.update(company_params)
      redirect_to companies_path(id: @company.id)
    else
      redirect_to companies_path(id: @company.id), alert: @company.errors.full_messages.join(', ')
    end
  end

  private

  def company_params
    params.expect(company: %i[name friendly_name address1 address2 city state county zip country description])
  end

  def set_company
    @company = Company.find_by(id: params[:id])
  end
end
