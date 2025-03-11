if Rails.application.config.influxdb[:enabled]
  influxdb_client = InfluxDB2::Client.new(
    Rails.application.config.influxdb[:host],
    Rails.application.config.influxdb[:token],
    bucket: Rails.application.config.influxdb[:bucket],
    org: Rails.application.config.influxdb[:org],
    precision: InfluxDB2::WritePrecision::NANOSECOND,
    use_ssl: Rails.application.config.influxdb[:use_ssl]
  )
  influxdb_write_api = influxdb_client.create_write_api

  ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |_name, started, finished, _unique_id, data| # rubocop:disable Layout/LineLength
    hash = {
      name: 'process_action.action_controller',
      tags: {
        method: "#{data[:controller]}##{data[:action]}",
        format: data[:format],
        http_method: data[:method],
        status: data[:status],
        exception: data[:exception]&.first
      },
      fields: {
        time_in_controller: (finished - started) * 1000,
        time_in_view: (data[:view_runtime] || 0).ceil,
        time_in_db: (data[:db_runtime] || 0).ceil
      },
      time: started
    }

    influxdb_write_api.write(data: hash)
  end

  ActiveSupport::Notifications.subscribe 'render_template.action_view' do |_name, started, finished, _unique_id, data|
    hash = {
      name: 'render_template.action_view',
      tags: {
        identifier: data[:identifier],
        layout: data[:layout],
        exception: data[:exception]&.first
      },
      fields: {
        duration: (finished - started) * 1000
      },
      time: started
    }

    influxdb_write_api.write(data: hash)
  end

  ActiveSupport::Notifications.subscribe 'sql.active_record' do |_name, started, finished, _unique_id, data|
    hash = {
      name: 'sql.active_record',
      tags: {
        name: data[:name],
        statement_name: data[:statement_name],
        exception: data[:exception]&.first
      },
      fields: {
        duration: (finished - started) * 1000
      },
      time: started
    }

    influxdb_write_api.write(data: hash)
  end
end
