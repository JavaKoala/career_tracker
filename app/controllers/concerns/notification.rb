module Notification
  extend ActiveSupport::Concern

  class_methods do
    def notifications(**)
      before_action(:find_notifications, **)
    end
  end

  private

  def find_notifications
    Rails.logger.info('Getting notifications')
  end
end
