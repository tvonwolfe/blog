module AuthHelpers
  include AdminSession

  def set_auth_cookie!
    cookie_jar.signed["Authorization"] = create_admin_token
  end
end
