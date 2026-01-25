# frozen_string_literal: true

module Components
  class Layout < Base
    include Phlex::Rails::Helpers::CSRFMetaTags
    include Phlex::Rails::Helpers::CSPMetaTag
    include Phlex::Rails::Helpers::StyleSheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::AutoDiscoveryLinkTag

    attr_reader :meta_tags

    register_element :use

    def initialize(title: "tvonwolfe", meta_tags: nil)
      @title = title
      @meta_tags = meta_tags || MetaTags.new
    end

    def view_template
      doctype

      html lang: "en-US" do
        head do
          title { @title }

          meta name: "viewport", content: "width=device-width,initial-scale=1"
          meta name: "apple-mobile-web-app-capable", content: "yes"
          meta name: "mobile-web-app-capable", content: "yes"
          meta charset: "utf-8"

          link href: "https://github.com/tvonwolfe", rel: "me"
          link href: "https://bsky.app/profile/tvonwolfe.com", rel: "me"

          csp_meta_tag

          stylesheet_link_tag :app, data: { turbo_track: "reload" }
          javascript_importmap_tags
          auto_discovery_link_tag :rss, feed_path

          render meta_tags
        end

        body class: "text-slate-700 dark:text-slate-200 bg-slate-100 dark:bg-[#141c2b] min-h-full p-4 md:p-8 min-h-screen flex flex-col justify-between" do
          div class: "flex flex-col lg:grid lg:grid-cols-[25%_50%_25%] grow" do
            header id: "header", class: "pt-2 pb-6 md:pt-0 flex flex-col-reverse sm:flex-col" do
              h1 class: "font-mono text-4xl font-bold" do
                a href: root_path do
                  plain "tvonwolfe"
                end
              end
              div id: "social-links", class: "flex space-between gap-3 sm:gap-4 mb-2 sm:mt-2 sm:mb-0 text-slate-500" do
                social_link name: "email", href: "mailto:me@tvonwolfe.com"
                social_link name: "github", href: "https://github.com/tvonwolfe"
                social_link name: "bluesky", href: "https://bsky.app/profile/tvonwolfe.com"
                social_link name: "rss", href: "/feed"
              end
            end
            main class: "md:max-w-2xl md:mx-auto" do
              yield
            end
          end
          footer class: "pt-4 sm:pt-0 w-full flex flex-col-reverse sm:flex-row sm:justify-between" do
            div id: "copyright", class: "flex flex-row sm:self-center text-slate-500" do
              p do
                raw safe "&copy;"
                plain " "
                raw safe Date.current.year.to_s
                plain " "
                plain "Tony Von Wolfe"
              end
            end
            div id: "meta-links", class: "flex flex-row sm:self-center space-between gap-3 sm:gap-4 text-slate-500" do
              if NowUpdate.any?
                a href: "/now", class: "link" do
                  "Now"
                end
              end
              # TODO: about page
              # a href: "/about", class: "hover:underline" do
              #   "About"
              # end
            end
          end
        end
      end
    end

    private

    def social_link(href:, name:)
      a href: do
        svg class: "social-link icon" do
          use href: "/icons.svg##{name}"
        end
      end
    end
  end
end
