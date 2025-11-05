class ApplicationController < ActionController::Base
  include AdminSession

  HTTP_CACHE_TTL = 1.hour.freeze

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Phlex handles layouts - disable the Rails built-in ones
  layout false

  rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to :root }

  before_action :skip_session_cookie, unless: :admin?
  before_action :enable_http_caching, unless: :admin?

  private

  # prevent session cookie from being set for non-admin viewers
  def skip_session_cookie
    request.session_options[:skip] = true
  end

  # configure the cache-control header. encourages HTTP caching by CDNs and
  # proxies. only for non-admins. we don't want to cache stuff for admin
  # sessions.
  def enable_http_caching
    expires_in HTTP_CACHE_TTL, public: true, must_revalidate: true
  end
end
