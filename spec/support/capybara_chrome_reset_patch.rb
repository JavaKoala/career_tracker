# frozen_string_literal: true

# Workaround for Chrome 158+ rejecting `origin: '*'` in the CDP command
# `Storage.clearDataForOrigin`, which Capybara 3.40.0 sends at the end of
# `ChromeDriver#reset!`. Chrome now fails with "* is not a valid URL",
# so every system spec errors in its teardown.
#
# Instead of the wildcard, clear all cookies with `Network.clearBrowserCookies`
# and clear storage for the origin the test was actually on.
#
# Remove this file once Capybara ships a fix.
module CapybaraChromeResetPatch
  def reset!
    @origin_before_reset = current_origin
    super
  ensure
    @origin_before_reset = nil
  end

  private

  def execute_cdp(cmd, params = {})
    return super unless cmd == 'Storage.clearDataForOrigin' && params[:origin] == '*'

    super('Network.clearBrowserCookies')
    super(cmd, params.merge(origin: @origin_before_reset)) if @origin_before_reset
  end

  def current_origin
    uri = URI.parse(current_url.to_s)
    return unless %w[http https].include?(uri.scheme)

    "#{uri.scheme}://#{uri.host}:#{uri.port}"
  rescue URI::InvalidURIError, Selenium::WebDriver::Error::WebDriverError
    nil
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(CapybaraChromeResetPatch)
