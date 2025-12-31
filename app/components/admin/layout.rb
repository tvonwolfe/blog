# frozen_string_literal: true

module Components
  module Admin
    class Layout < Base
      include Phlex::Rails::Helpers::CSRFMetaTags
      include Phlex::Rails::Helpers::CSPMetaTag
      include Phlex::Rails::Helpers::StyleSheetLinkTag
      include Phlex::Rails::Helpers::JavaScriptImportmapTags

      def initialize(title: "Admin | tvonwolfe", header: true)
        @title = title
        @header = header
      end

      def view_template
        doctype
        html(lang: "en-US") do
          head do
            title { @title }
            link rel: "icon", type: "image/x-icon", href: "/favicon.png"

            meta name: "viewport", content: "width=device-width,initial-scale=1"
            meta name: "apple-mobile-web-app-capable", content: "yes"
            meta name: "mobile-web-app-capable", content: "yes"

            csrf_meta_tags
            csp_meta_tag

            stylesheet_link_tag :app, data: { turbo_track: "reload" }
            javascript_importmap_tags
          end

          body class: "min-h-screen" do
            render Components::Admin::Header if header?
            main class: "w-2xl mx-auto py-6 px-4" do
              yield
            end
          end
        end
      end

      private

      def header? = @header
    end
  end
end
