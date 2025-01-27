class HomeController < ApplicationController
  def index
    @new_application = JobApplication.new
    @new_application.position = Position.new
    @new_application.position.company = Company.new
  end
end
