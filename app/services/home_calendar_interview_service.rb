class HomeCalendarInterviewService
  def initialize(interview_id)
    interview(interview_id)
    home_calendar_event
    faraday_connection
  end

  def create_event
    return if @faraday_connection.blank?

    response = @faraday_connection.post('/api/v1/events', @home_calendar_event.to_json)
    get_home_calendar_event_from_response(response)

    @interview.update!(home_calendar_event_id: @api_event.id) if @api_event.present?
  end

  private

  def interview(interview_id)
    @interview = Interview.find_by(id: interview_id)
    Rails.logger.info("Interview not found for id: #{interview_id}") if @interview.blank?
  end

  def home_calendar_event
    return if @interview.blank?

    @home_calendar_event = HomeCalendarEvent.new
    @home_calendar_event.assign_attributes(
      id: @interview.home_calendar_event_id,
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
    if @home_calendar_event.blank? || @home_calendar_event.invalid? || !Rails.application.config.home_calendar[:enabled]
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

  def get_home_calendar_event_from_response(response)
    event_from_api = HomeCalendarEvent.new
    JSON.parse(response.body).tap do |events|
      event_from_api.assign_attributes(events.first)
    end

    @api_event = event_from_api if event_from_api.valid?
  end
end
