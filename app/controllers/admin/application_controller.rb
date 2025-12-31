module Admin
  class ApplicationController < ::ApplicationController
    before_action :authorize_admin_session

    private

    def authorize_admin_session
      return if admin?

      redirect_to :root
    end
  end
end
