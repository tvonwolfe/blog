  # frozen_string_literal: true

  module Views
    module Admin
      module Posts
        class New < Base
          attr_reader :post

          def initialize(post: nil)
            @post = post || Post.new
          end

          def view_template
            render Components::Admin::Layout.new(title: "New Post") do
              a href: admin_posts_path, class: "text-slate-600 hover:underline" do
                "← All Posts"
              end
              h1 class: "text-3xl font-bold my-2" do
                "New Post"
              end
              render Components::Admin::Posts::Form.new(post:)
            end
          end
        end
      end
    end
  end
