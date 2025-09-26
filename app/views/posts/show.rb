module Views
  module Posts
    class Show < Base
      attr_reader :post

      def initialize(post:)
        @post = post
      end

      def view_template
        render Components::Layout.new(title: post.title) do
          div class: "my-6" do
            h1 class: "text-5xl font-extrabold mb-2 text-slate-700 dark:text-amber-50" do
              post.title
            end
            p class: "text-slate-500 dark:text-slate-300 text-sm font-sans" do
              if post.published?
                "Published on #{post.published_at&.to_date}"
              else
                "Not published"
              end
            end
          end
          article class: "blog-post" do
            raw safe post.html_content
          end
          render Components::Posts::Tags.new(post)
        end
      end
    end
  end
end
