module Components
  module Admin::Now
    class Form < Base
      include Phlex::Rails::Helpers::FormAuthenticityToken

      attr_reader :now_update

      def initialize(now_update:)
        @now_update = now_update
      end

      def view_template
        div class: "w-full" do
          render errors

          form action: admin_now_index_path, method: :post, class: "w-full" do
            form_authenticity_token

            div class: "flex flex-col" do
              marksmith_tag "now_update[content]", value: now_update.content
            end
            div class: "flex justify-end" do
              input type: :submit, class: "w-full sm:w-auto mt-4 p-2 px-6 rounded-sm text-slate-100 bg-slate-700 hover:bg-slate-600 hover:cursor-pointer", value: "Save & Publish"
            end
          end
        end
      end

      private

      def errors = Components::ErrorList.new(now_update.errors)
    end
  end
end
