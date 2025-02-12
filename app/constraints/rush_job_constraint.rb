class RushJobConstraint
  def self.matches?(request)
    cookies = ActionDispatch::Cookies::CookieJar.build(request, request.cookies)

    if cookies.signed[:session_id]
      Session.find_by(id: cookies.signed[:session_id]) ? true : false
    else
      false
    end
  end
end
