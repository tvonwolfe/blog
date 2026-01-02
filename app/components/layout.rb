# frozen_string_literal: true

module Components
  class Layout < Base
    include Phlex::Rails::Helpers::CSRFMetaTags
    include Phlex::Rails::Helpers::CSPMetaTag
    include Phlex::Rails::Helpers::StyleSheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::AutoDiscoveryLinkTag

    attr_reader :meta_tags

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
            header id: "header", class: "pt-2 pb-6 md:pt-0" do
              h1 class: "font-mono text-4xl font-bold" do
                a href: root_path do
                  plain "tvonwolfe"
                end
              end
            end
            main class: "md:max-w-2xl md:mx-auto" do
              yield
            end
          end
          footer class: "pt-4 sm:pt-0 flex w-full justify-between" do
            div id: "copyright", class: "flex flex-row self-center text-slate-500" do
              p do
                raw safe "&copy;"
                plain " "
                raw safe Date.current.year.to_s
                plain " "
                plain "Tony Von Wolfe"
              end
            end

            div class: "self-center" do
              a href: feed_url, data: { turbo: "false" } do
                img src: "/rss.svg", height: "24px", width: "24px", alt: "rss feed"
              end
            end
          end
        end
      end
    end

    private

    def theme_toggle_script
      script do
        raw safe <<-JS
        const THEME_OPTIONS = {
          light: "light",
          dark: "dark",
        };

        const setTheme = (theme) => {
          document.documentElement.dataset.theme = theme;
          localStorage.theme = theme
        };

        // set up listener to auto-toggle on system theme change
        const colorSchemeMediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
        colorSchemeMediaQuery.addEventListener("change", (e) => {
          const theme = (e.matches) ? THEME_OPTIONS.dark : THEME_OPTIONS.light;
          setTheme(theme);
        })

        // set theme on page load. if we have a theme stored already, use that.
          // otherwise, use the detected the browser/system setting.
          const shouldUseDarkTheme = localStorage.theme === "dark" ||
          (!("theme" in localStorage) && colorSchemeMediaQuery.matches);

        const theme = shouldUseDarkTheme ? THEME_OPTIONS.dark : THEME_OPTIONS.light;
        setTheme(theme);
        JS
      end
    end
  end
end
