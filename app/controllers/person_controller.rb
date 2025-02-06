class PersonController < ApplicationController
  before_action :set_company, only: %i[create]

  def create
    @person = Person.new(person_params)

    if @company.blank?
      redirect_to root_path, alert: t(:company_not_found)
    elsif @person.save
      redirect_to company_path(@company)
    else
      redirect_to company_path(@company), alert: @person.errors.full_messages.join(', ')
    end
  end

  private

  def person_params
    params.expect(person: %i[name email_address company_id])
  end

  def set_company
    @company = Company.find_by(id: person_params[:company_id])
  end
end
