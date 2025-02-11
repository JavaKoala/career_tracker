class HomeCalendarInterviewService
  def initialize
    faraday_connection
  end

  def create_event(interview_id)
    return if @faraday_connection.blank?

    interview(interview_id)
    return if @interview.blank? || @interview.home_calendar_event_id.present?

    home_calendar_event
    return if @home_calendar_event.invalid?

    response = @faraday_connection.post('/api/v1/events', @home_calendar_event.to_json)
    get_event_id_from_response(response)

    @interview.update!(home_calendar_event_id: @api_event_id) if @api_event_id.present?
  end

  def update_event(interview_id)
    return if @faraday_connection.blank?

    interview(interview_id)
    return if @interview.blank? || @interview.home_calendar_event_id.blank?

    home_calendar_event
    return if @home_calendar_event.invalid?

    @faraday_connection.patch("/api/v1/events/#{@interview.home_calendar_event_id}", @home_calendar_event.to_json)
  rescue Faraday::ResourceNotFound
    Rails.logger.info("Event not found for id: #{@interview.home_calendar_event_id}")
  end

  def delete_event(event_id)
    return if @faraday_connection.blank?

    @faraday_connection.delete("/api/v1/events/#{event_id}")
  rescue Faraday::ResourceNotFound
    Rails.logger.info("Event not found for id: #{event_id}")
  end

  private

  def interview(interview_id)
    @interview = Interview.find_by(id: interview_id)
    Rails.logger.info("Interview not found for id: #{interview_id}") if @interview.blank?
  end

  def home_calendar_event
    @home_calendar_event = HomeCalendarEvent.new
    @home_calendar_event.assign_attributes(
      title: event_title,
      start: @interview.interview_start,
      end: @interview.interview_end,
      color: Rails.application.config.home_calendar[:color]
    )
  end

  def event_title
    "#{I18n.t(:interview_for)} #{@interview.job_application.position_name} #{I18n.t(:at)} \
     #{@interview.company.name} - #{@interview.location}"
  end

  def faraday_connection
    unless Rails.application.config.home_calendar[:enabled]
      Rails.logger.info('Home calendar event is invalid or disabled')
      return
    end

    @faraday_connection = Faraday.new(
      url: Rails.application.config.home_calendar[:url],
      headers: { 'Content-Type' => 'application/json' }
    ) do |faraday|
      faraday.response :raise_error
    end
  end

  def get_event_id_from_response(response)
    JSON.parse(response.body).tap do |events|
      @api_event_id = events.first.fetch('id', nil)
    end
  end
end
