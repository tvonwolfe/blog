# frozen_string_literal: true

module Views
  module Admin
    module Posts
      class Index < Base
        attr_reader :posts

        def initialize(posts:)
          @posts = posts
        end

        def view_template
          render Components::Admin::Layout do
            div class: "flex justify-between items-center mb-2" do
              h1 class: "text-3xl" do
                "Posts"
              end
              a href: new_admin_post_path, class: "text-slate-100 p-2 bg-slate-700 rounded-sm" do
                "New Post"
              end
            end
            posts_list
          end
        end

        private

        def posts_list
          ol do
            posts.each do |post|
              posts_list_item(post)
            end
          end
        end

        def posts_list_item(post)
          li class: "p-1 hover:bg-slate-100 rounded-sm" do
            div do
              a href: edit_admin_post_path(post) do
                h3 class: "text-xl font-bold" do
                  post.title
                end

                p do
                  if post.published?
                    plain "Published at "
                    time datetime: post.published_at do
                      post.published_at.to_s
                    end
                  else
                    em { "Not published" }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
