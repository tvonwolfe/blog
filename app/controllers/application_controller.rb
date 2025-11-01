class ApplicationController < ActionController::Base
  include AdminSession

  HTTP_CACHE_TTL = 1.hour.freeze

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Phlex handles layouts - disable the Rails built-in ones
  layout false

  rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to :root }

  private

  # prevent the session cookie from being set, and configure the cache-control
  # header. encourages HTTP caching by CDNs and proxies.
  #
  # only for non-admins. we don't want to cache stuff for admin sessions.
  def enable_http_caching
    return if admin?

    request.session_options[:skip] = true
    expires_in HTTP_CACHE_TTL, public: true, must_revalidate: true
  end
end
