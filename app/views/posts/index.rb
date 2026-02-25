# frozen_string_literal: true

module Views
  module Posts
    class Index < Base
      include Phlex::Rails::Helpers::Request

      attr_reader :posts, :paginator, :params

      def initialize(posts:, paginator:, params:)
        @posts = posts
        @paginator = paginator
        @params = params
      end

      def view_template
        render Components::Layout do
          tag_filter
          div id:, class: "mx-auto" do
            posts.each { |post| post_link(post) }
          end
          raw safe paginator.series_nav unless paginator.last == 1
        end
      end

      def id = "posts-list"

      private

      def tag_filter
        return unless tags.present?

        h2 class: "text-3xl font-bold mb-8 border-b border-slate-400 dark:border-slate-600 pb-2" do
          plain "Posts tagged #{tags.join(", ")}"
        end
      end

      def tags
        return unless params.key? :tag

        params[:tag].map { |tag_str| "##{tag_str}" }
      end

      def post_link(post)
        div class: "mb-2" do
          h1 class: "text-2xl font-semibold" do
            a href: post_path(handle: post.handle), class: "hover:underline underline-offset-4" do
              post.title
            end
          end
          time datetime: post.published_at&.to_date, class: "text-slate-500 dark:text-slate-400 text-sm font-sans" do
            published_date(post)
          end
        end
      end

      def published_date(post)
        post.published_at&.strftime(Views::Posts::Show::DATE_FORMAT)
      end
    end
  end
end
