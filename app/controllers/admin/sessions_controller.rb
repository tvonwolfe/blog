module Admin
  class SessionsController < ApplicationController
    skip_before_action :verify_admin_session

    def create
      if Rack::Utils.secure_compare(password_param_digest, password_digest)
        set_authorization_cookie!
        redirect_to admin_dashboard_path
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
