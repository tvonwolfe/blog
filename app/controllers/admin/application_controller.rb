module Admin
  class ApplicationController < ::ApplicationController
    before_action :verify_admin_session

    private

    def verify_admin_session
      return if admin?

      redirect_to :root
    end
  end
end
