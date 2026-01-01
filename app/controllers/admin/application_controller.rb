module Admin
  class ApplicationController < ::ApplicationController
    include AdminSession

    before_action :authorize_admin_session

    def authorize_admin_session
      return if admin?

      redirect_to :root
    end
  end
end
