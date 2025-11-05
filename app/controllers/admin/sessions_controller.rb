module Admin
  class SessionsController < ApplicationController
    skip_before_action :verify_admin_session
    skip_before_action :skip_session_cookie
    skip_before_action :enable_http_caching

    before_action :redirect_if_logged_in, only: :new

    def create
      if Rack::Utils.secure_compare(password_param_digest, password_digest)
        set_authorization_cookie!
        redirect_to admin_posts_path
      else
        render Views::Admin::Sessions::New, status: :bad_request
      end
    end

    def new
      render Views::Admin::Sessions::New
    end

    def destroy
      clear_authorization_cookie!
      redirect_to :root
    end

    private

    def redirect_if_logged_in
      redirect_to admin_posts_path if admin?
    end

    def password_digest
      Digest::SHA256.hexdigest(Rails.application.credentials.admin_password)
    end

    def password_param_digest
      Digest::SHA256.hexdigest(password_param)
    end

    def password_param
      params.dig(:session, :password)
    end
  end
end
