# frozen_string_literal: true

module Views
  module Posts
    class Show < Base
      attr_reader :post

      DATE_FORMAT = "%B %d, %Y"

      def initialize(post:)
        @post = post
      end

      def view_template
        render Components::Layout.new(title: post.title) do
          post_title
          article class: "blog-post" do
            raw safe post_html_content
          end
        end
      end

      def post_html_content
        Rails.cache.fetch("#{post.cache_key_with_version}-rendered-md") do
          Commonmarker.to_html(post.content, **Rails.application.config.commonmarker)
        end
      end

      private

      def post_title
        div class: "pb-8" do
          h1 class: "text-5xl font-extrabold" do
            post.title
          end
          div class: "pt-4 text-slate-500 dark:text-slate-400 text-sm font-sans flex gap-2 items-center" do
            if post.published?
              published_date
            else
              "Not published"
            end
            hr class: "flex-1 h-1 text-slate-300 dark:text-slate-600"
            render Components::Posts::Tags.new(post)
          end
        end
      end

      def published_date
        time datetime: post.published_at&.to_date do
          post.published_at&.strftime(DATE_FORMAT)
        end
      end
    end
  end
end
