# frozen_string_literal: true

module AdminSession
  extend ActiveSupport::Concern

  KEY_SIGNING_ALGO = "HS256"

  private

  def clear_authorization_cookie!
    cookies.delete "Authorization"
  end

  def set_authorization_cookie!
    cookies.signed["Authorization"] = {
      value: create_admin_token,
      http_only: true,
      expires: 1.month,
      secure: Rails.env.production?,
      same_site: :strict
    }
  end

  def create_admin_token
    payload = {
      iat: Time.current.to_i,
      exp: 1.month.from_now.to_i,
      iss: root_url
    }

    JWT.encode(
      payload,
      Rails.application.secret_key_base,
      KEY_SIGNING_ALGO
    )
  end

  def admin? = admin_token.present?

  def admin_token
    return if authorization_cookie.blank?

    @admin_token ||= JWT.decode(
      authorization_cookie,
      Rails.application.secret_key_base,
      true,
      { algorithm: "HS256" }
    )
  rescue JWT::DecodeError => e
    Rails.logger.error(self.class.name) do
      "Failed to decode token: #{e.message}"
    end

    nil
  end

  def authorization_cookie = cookies.signed["Authorization"]
end
