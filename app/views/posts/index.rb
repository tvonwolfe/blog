module Views
  module Posts
    class Index < Base
      include Pagy::Frontend
      include Phlex::Rails::Helpers::Request

      attr_reader :posts, :paginator

      def initialize(posts:, paginator:)
        @posts = posts
        @paginator = paginator
      end

      def view_template
        render Components::Layout do
          div id:, class: "mb-6" do
            posts.each { |post| post_link(post) }
            raw safe pagy_nav(paginator) unless paginator.last == 1 # don't show the paginator if there's only one page.
          end
        end
      end

      def id = "posts-list"

      private

      def post_link(post)
        div class: "mb-2" do
          h1 class: "text-2xl font-bold text-slate-700 dark:text-amber-50" do
            a href: post_path(post), class: "hover:underline underline-offset-4" do
              post.title
            end
          end
          p class: "text-slate-500 dark:text-slate-300 text-sm font-sans" do
            post.published_at&.to_date&.to_s
          end
        end
      end
    end
  end
end
