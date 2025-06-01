class ImportJobApplications
  def initialize(user_id)
    @user = User.find(user_id)
  end

  def perform
    @user.job_application_import.open do |file|
      CSVSafe.foreach(file, headers: true) do |row|
        create_job_application(row)
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to import job applications for user #{@user.id}: #{e.message}")
    raise e
  end

  private

  def create_job_application(row) # rubocop:disable Metrics/MethodLength
    @company = Company.find_or_create_by(name: row['Company name']) do |company|
      company.description = row['Company description']
    end

    JobApplication.create!(
      source: row['Source'],
      active: row['Active'].downcase == 'true',
      user: @user,
      position_attributes: {
        name: row['Position name'],
        description: row['Position description'],
        pay_start: row['Position pay start'].gsub(/\$|,/, ''),
        pay_end: row['Position pay end'].gsub(/\$|,/, ''),
        location: row['Position location'].downcase,
        company: @company
      }
    )
  end
end
