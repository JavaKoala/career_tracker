class AddHomeCalendarEventIdToInterviews < ActiveRecord::Migration[8.0]
  def change
    add_column :interviews, :home_calendar_event_id, :bigint
  end
end
