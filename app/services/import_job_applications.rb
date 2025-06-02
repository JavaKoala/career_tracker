class ImportJobApplications
  def initialize(user_id)
    @user = User.find(user_id)
    @sanitizer = Rails::HTML5::FullSanitizer.new
  end

  def perform
    return if @user.import_error.present?

    import_applications
    @user.update(importing_job_applications: false)
  rescue StandardError => e
    Rails.logger.error("Failed to import job applications for user #{@user.id}: #{e.message}")
    @user.update(import_error: e.message)
    raise e
  end

  private

  def import_applications
    @user.job_application_import.open do |file|
      CSVSafe.foreach(file, headers: true) do |row|
        create_job_application(row)
      end
    end
  end

  def create_job_application(row)
    sanitize_row(row)

    JobApplication.create!(
      source: row['Source'],
      active: row['Active'].downcase == 'true',
      user: @user,
      position_attributes: position_attributes(row)
    )
  end

  def sanitize_row(row)
    row_length = row.length
    (0...row_length).each do |i|
      row[i] = @sanitizer.sanitize(row[i])
    end
  end

  def position_attributes(row)
    company = find_or_create_company(row)

    {
      name: row['Position name'],
      description: row['Position description'],
      pay_start: row['Position pay start']&.gsub(/\$|,/, ''),
      pay_end: row['Position pay end']&.gsub(/\$|,/, ''),
      location: row['Position location']&.downcase,
      company: company
    }
  end

  def find_or_create_company(row)
    Company.find_or_create_by(name: row['Company name']) do |company|
      company.description = row['Company description']
    end
  end
end
