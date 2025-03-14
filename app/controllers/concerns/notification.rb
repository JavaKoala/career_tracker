module Notification
  extend ActiveSupport::Concern

  included do
    helper_method :next_steps_due_today?
    helper_method :next_steps_past_due?
  end

  class_methods do
    def notifications(**)
      before_action(:find_notifications, **)
    end
  end

  private

  def find_notifications
    @next_steps_past_due = NextStep.past_due(Current.user).count
    @next_steps_due_today = NextStep.due_today(Current.user).count
  end

  def next_steps_due_today?
    @next_steps_due_today.positive?
  end

  def next_steps_past_due?
    @next_steps_past_due.positive?
  end
end
