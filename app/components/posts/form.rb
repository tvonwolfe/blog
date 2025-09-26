module Components
  module Posts
    class Form < Base
      attr_reader :post

      def initialize(post: nil)
        @post = post
      end

      def view_template
        form action: admin_posts_path, method: :post do
          input type: :hidden, name: "post[content]", value: post&.content
          # TODO: figure out linkage with milkdown
          div class: "min-h-[500px]", data: {}
        end
      end
    end
  end
end
