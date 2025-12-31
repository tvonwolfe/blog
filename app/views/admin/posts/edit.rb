# frozen_string_literal: true

module Views
  module Admin
    module Posts
      class Edit < Base
        attr_reader :post

        def initialize(post:)
          @post = post
        end

        def view_template
          render Components::Admin::Layout.new(title: "Edit Post") do
            a href: admin_posts_path, class: "text-slate-600 hover:underline" do
              "← All Posts"
            end
            h1 class: "text-3xl font-bold my-2" do
              "Edit Post"
            end
            render Components::Admin::Posts::Form.new(post:)
          end
        end
      end
    end
  end
end
