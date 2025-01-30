class PositionController < ApplicationController
  def show
    @position = Position.find_by(id: params[:id])

    redirect_to root_path, alert: t(:position_not_found) unless @position
  end
end
