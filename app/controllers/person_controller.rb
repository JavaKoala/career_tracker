class PersonController < ApplicationController
  before_action :set_company, only: %i[create]
  before_action :set_person, only: %i[update]

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

  def update
    if @person.blank?
      redirect_to root_path, alert: t(:person_not_found)
    elsif @person.update(person_params)
      redirect_back_or_to company_path(@person.company)
    else
      redirect_back_or_to company_path(@person.company), alert: @person.errors.full_messages.join(', ')
    end
  end

  def destroy
    @person = Person.find_by(id: params[:id])

    if @person.blank?
      redirect_to root_path, alert: t(:person_not_found)
    else
      @person.destroy
      redirect_to company_path(@person.company), notice: t(:deleted_person)
    end
  end

  private

  def person_params
    params.expect(person: %i[name email_address company_id])
  end

  def set_company
    @company = Company.find_by(id: person_params[:company_id])
  end

  def set_person
    @person = Person.find_by(id: params[:id])
  end
end
