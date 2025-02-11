class PositionsController < ApplicationController
  before_action :set_position, only: %i[show update]

  def show
    redirect_to root_path, alert: t(:position_not_found) unless @position
  end

  def create
    @position = Position.new(position_params)

    if @position.save
      redirect_to position_path(@position), notice: t(:created_position)
    else
      redirect_to company_path(id: position_params[:company_id]), alert: @position.errors.full_messages.join(', ')
    end
  end

  def update
    if @position.blank?
      redirect_to root_path, alert: t(:position_not_found)
    elsif @position.update(position_params)
      redirect_to position_path(@position), notice: t(:updated_position)
    else
      redirect_to position_path(@position), alert: @position.errors.full_messages.join(', ')
    end
  end

  private

  def position_params
    params.expect(position: %i[name description pay_start pay_end location company_id])
  end

  def set_position
    @position = Position.find_by(id: params[:id])
  end
end
