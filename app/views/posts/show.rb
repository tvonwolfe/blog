# frozen_string_literal: true

module Views
  module Posts
    class Show < Base
      attr_reader :post, :meta_tags

      DATE_FORMAT = "%B %d, %Y"

      before_template :set_metadata

      def initialize(post:)
        @post = post
        @meta_tags = Components::MetaTags.new
      end


      def view_template
        render Components::Layout.new(title: post.title, meta_tags: meta_tags) do
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

      def set_metadata
        meta_tags.add property: "og:title", content: post.title
        meta_tags.add property: "og:type", content: "article"
        meta_tags.add property: "og:url", content: post_url(post)
      end

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
