module Alert
  extend ActiveSupport::Concern

  class_methods do
    def find_alerts(**)
      before_action(:alerts, **)
    end
  end

  private

  def alerts
    Rails.logger.info('Getting alerts')
  end
end
