class SettingsController < ApplicationController
  notifications

  def index
    @user = Current.user
  end
end
