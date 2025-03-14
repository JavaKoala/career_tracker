class HomeController < ApplicationController
  find_alerts
  include Pagy::Backend

  def index
    @new_application = JobApplication.new
    @new_application.position = Position.new
    @new_application.position.company = Company.new
    @pagy, @active_applications = pagy(Current.user.active_applications)
  end
end
