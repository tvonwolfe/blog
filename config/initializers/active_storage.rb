# add authorization layer to activestorage controllers
Rails.application.config.to_prepare do
  ActiveStorage::DirectUploadsController.class_eval do
    include AdminSession

    before_action :authorize_admin_session

    def authorize_admin_session
      return if admin?

      head :forbidden
    end
  end

  ActiveStorage::DiskController.class_eval do
    include AdminSession

    before_action :authorize_admin_session, only: :update

    def authorize_admin_session
      return if admin?

      head :forbidden
    end
  end
end
