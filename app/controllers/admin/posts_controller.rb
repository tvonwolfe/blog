# frozen_string_literal: true

module Admin
  class PostsController < ApplicationController
    before_action :set_post, except: %i[create index new]
    before_action :set_posts, only: :index

    rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to admin_posts_path }

    # TODO: pagy
    def index
      render Views::Admin::Posts::Index.new(posts:)
    end

    def create
      post = PostCreator.new(post_params).create_post

      if post.persisted?
        redirect_to post_path(post)
      else
        render Views::Admin::Posts::New.new(post:), status: :unprocessable_content
      end
    end

    def edit
      render Views::Admin::Posts::Edit.new(post:)
    end

    def update
      post_updater = PostUpdater.new(post)
      updated_post = post_updater.update(post_params)

      if updated_post.errors.none?
        redirect_to admin_posts_path
      else
        render Views::Admin::Posts::Edit.new(post: updated_post), status: :unprocessable_content
      end
    end

    def new
      render Views::Admin::Posts::New
    end

    private

    attr_reader :post, :posts

    def set_post
      @post = Post.find_by!(handle: params[:handle])
    end

    def set_posts
      @posts = Post.all
    end

    def post_params
      @post_params ||= params.require(:post).permit(
        :title,
        :content,
        :tags,
        :publish,
        :unpublish,
      ).tap do |post_params|
        post_params[:tags] = Array(post_params.extract_value(:tags, delimiter: " ")).map(&:strip)
        post_params[:publish] = ActiveModel::Type::Boolean.new.cast(post_params[:publish])

        if action_name.to_sym == :update
          post_params[:unpublish] = ActiveModel::Type::Boolean.new.cast(post_params[:unpublish])
        else
          post_params.delete(:unpublish)
        end
      end
    end
  end
end
