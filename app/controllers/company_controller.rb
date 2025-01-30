class CompanyController < ApplicationController
  before_action :set_company, only: %i[show update]

  def index
    @companies = Company.all
    @new_company = Company.new
  end

  def show
    @position = Position.new(company: @company)
    redirect_to root_path, alert: t(:company_not_found) unless @company
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to company_path(@company), notice: t(:created_company)
    else
      redirect_to company_index_path, alert: @company.errors.full_messages.join(', ')
    end
  end

  def update
    if @company.blank?
      redirect_to root_path, alert: t(:company_not_found)
    elsif @company.update(company_params)
      redirect_to company_path(id: @company.id), notice: t(:updated_company)
    else
      redirect_to company_path(id: @company.id), alert: @company.errors.full_messages.join(', ')
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
