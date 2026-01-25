class NowController < ApplicationController
  before_action :set_now_update
  before_action :enable_http_caching

  def index
    render Views::Now::Index.new(now_update) if !Rails.env.production? || stale?(now_update)
  end

  private

  attr_reader :now_update

  def set_now_update
    @now_update = NowUpdate.last

    # don't show the /now page if there's nothing to render yet
    redirect_to :root, status: :temporary_redirect if @now_update.blank?
  end
end
