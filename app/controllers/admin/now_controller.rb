module Admin
  class NowController < ApplicationController
    before_action :set_now_page_update, except: %i[create new]

    rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to admin_posts_path }

    def create
      now_update = NowUpdate.new(now_update_params)

      if now_update.save
        redirect_to now_index_path
      else
        render Views::Admin::Now::New.new(now_update:), status: :unprocessable_content
      end
    end

    def new
      render Views::Admin::Now::New
    end

    def destroy
      now_update = NowUpdate.find(params[:id])

      if now_update.destroy
        redirect_to admin_posts_path
      else
        head :bad_request
      end
    end

    private

    def now_update_params = params.require(:now_update).permit(:content)
  end
end
