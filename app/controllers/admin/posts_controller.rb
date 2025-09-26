module Admin
  class PostsController < ApplicationController
    def create
      post = Post.new(create_params)

      if post.save
        redirect_to post
      else
        render Views::Admin::Posts::New
      end
    end

    def new
      render Views::Admin::Posts::New
    end

    private

    def create_params
      params.require(:post).permit(
        :title,
        :content

      )
    end
  end
end
