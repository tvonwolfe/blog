module Views
  module Admin::Now
    class New < Base
      attr_reader :now_update

      def initialize(now_update: nil)
        @now_update = now_update || NowUpdate.new
      end

      def view_template
        render Components::Admin::Layout.new(title: "Update Now Page") do
        a href: admin_posts_path, class: "text-slate-600 hover:underline" do
          "← Back"
        end
        h1 class: "text-3xl font-bold my-2" do
          "Now Page Update"
        end
        render Components::Admin::Now::Form.new(now_update:)
        end
      end
    end
  end
end
