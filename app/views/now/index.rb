module Views
  module Now
    class Index < Base
      attr_reader :now_update, :meta_tags

      DATE_FORMAT = "%B %d, %Y"

      before_template :set_metadata

      def initialize(now_update)
        @now_update = now_update
        @meta_tags = Components::MetaTags.new
      end

      def view_template
        render Components::Layout.new(title: "Now | tvonwolfe", meta_tags:) do
          div class: "pb-6" do
            h1 class: "text-5xl font-extrabold" do
              "Now"
            end
            div class: "pt-4 text-slate-500 dark:text-slate-400 text-sm gap-2 items-center" do
              div class: "pb-2" do
                plain "Last updated: "
                time datetime: now_update.created_at do
                  now_update.created_at&.strftime(DATE_FORMAT)
                end
              end
              a href: "https://nownownow.com/about", class: "link" do
                em { "What is this?" }
              end
            end
          end

          article class: "blog-post" do
            raw safe html_content
          end
        end
      end

      private

      def html_content
        Rails.cache.fetch("#{now_update.cache_key_with_version}-rendered-md") do
          Commonmarker.to_html(now_update.content, **Rails.application.config.commonmarker)
        end
      end

      def set_metadata
        meta_tags.add property: "og:title", content: "Now | tvonwolfe"
        meta_tags.add property: "og:type", content: "article"
        meta_tags.add property: "og:url", content: now_index_url
        meta_tags.add property: "og:description", content: "What I'm doing these days."
        meta_tags.add property: "og:locale", content: "en_US"
        meta_tags.add property: "article:author", content: "Tony Von Wolfe"
        meta_tags.add property: "article:published_time", content: now_update.created_at
      end
    end
  end
end
