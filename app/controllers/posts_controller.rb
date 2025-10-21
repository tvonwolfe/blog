class PostsController < ApplicationController
  include Pagy::Backend

  before_action :set_posts, only: :index
  before_action :set_post, only: :show

  before_action :enable_http_caching, only: :show

  rescue_from Pagy::OverflowError, with: -> { redirect_to :root }

  def index
    respond_to do |format|
      format.html { render Views::Posts::Index.new(posts:, paginator:, params: index_params) }
      format.rss
    end
  end

  def show
    render Views::Posts::Show.new(post:) if !Rails.env.production? || stale?(post)
  end

  private

  attr_reader :posts, :post, :paginator

  def set_post
    @post = Post.published.find_by!(handle: params[:handle])
  end

  def set_posts
    return @paginator, @posts if defined?(@paginator) && defined?(@posts)

    post_scope = Post.published.display_order
    post_scope = post_scope.tagged_with index_params[:tag] if index_params.key? :tag
    post_scope = post_scope.titled index_params[:title] if index_params.key? :title

    @paginator, @posts = pagy(post_scope)
  end

  def index_params
    params.permit(:page, :tag, :title).tap do |index_params|
      index_params[:tag] = Array(index_params.extract_value(:tag, delimiter: ",").map(&:strip)) if index_params.key? :tag
    end
  end
end
