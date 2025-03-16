class HomeController < ApplicationController
  notifications
  include Pagy::Backend

  def index
    @new_application = JobApplication.new
    @new_application.position = Position.new
    @new_application.position.company = Company.new
    @next_step_count = NextStep.ready_next_steps(Current.user).count
    @pagy, @active_applications = pagy(Current.user.active_applications)
  end
end
