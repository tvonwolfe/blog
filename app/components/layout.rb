# frozen_string_literal: true

module Components
  class Layout < Base
    include Phlex::Rails::Helpers::CSRFMetaTags
    include Phlex::Rails::Helpers::CSPMetaTag
    include Phlex::Rails::Helpers::StyleSheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::AutoDiscoveryLinkTag
    include Phlex::Rails::Helpers::ImagePath

    def initialize(title: "tvonwolfe")
      @title = title
    end

    def view_template
      doctype

      html lang: "en-US" do
        head do
          title { @title }

          link rel: "preconect", href: "https://fonts.googleapis.com"
          link rel: "preconect", href: "https://fonts.gstatic.com", crossorigin: true
          link href: "https://fonts.googleapis.com/css2?family=Inria+Serif&display=swap", rel: "stylesheet"
          link rel: "icon", type: "image/x-icon", href: "/favicon.png"

          meta name: "viewport", content: "width=device-width,initial-scale=1"
          meta name: "apple-mobile-web-app-capable", content: "yes"
          meta name: "mobile-web-app-capable", content: "yes"

          csrf_meta_tags
          csp_meta_tag

          stylesheet_link_tag :app, data: { turbo_track: "reload" }
          javascript_importmap_tags
          auto_discovery_link_tag :rss, feed_path

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

        body class: "bg-stone-100 dark:bg-slate-800 text-stone-800 dark:text-slate-100 w-auto md:max-w-[40rem] mx-auto min-h-screen flex flex-col" do
          header id: "header", class: "px-4 py-4 sm:px-6" do
            h1 class: "font-mono text-[2em] sm:text-[4em] text-slate-700 dark:text-amber-50 font-extrabold" do
              a href: root_path do
                plain "tvonwolfe"
              end
            end
          end
          main class: "mx-auto px-4 sm:px-6 grow w-full" do
            yield
          end
          footer id: "footer", class: "mt-2 px-4 py-4 sm:px-6" do
            div class: "flex w-full justify-between" do
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
    end
  end
end
