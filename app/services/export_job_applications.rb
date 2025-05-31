class ExportJobApplications
  EXPORT_ATTRIBUTES = %w[position_name position_description position_pay_start position_pay_end position_location
                         company_name company_description source applied active].freeze

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def perform
    job_applications = @user.job_applications

    io = StringIO.new(generate_csv(job_applications))

    @user.job_application_export.attach(io: io,
                                        filename: "job_applications_#{Time.current.to_i}.csv",
                                        content_type: 'text/csv')

    io.close

    @user.update!(exporting_job_applications: false)
  end

  private

  def generate_csv(job_applications)
    CSVSafe.generate(headers: true) do |csv|
      csv << EXPORT_ATTRIBUTES.map(&:humanize)

      job_applications.each do |application|
        csv << csv_line(application)
      end
    end
  end

  def csv_line(application)
    EXPORT_ATTRIBUTES.map do |attr|
      if application.public_send(attr).respond_to?(:to_plain_text)
        application.public_send(attr).to_plain_text
      else
        application.public_send(attr)
      end
    end
  end
end
