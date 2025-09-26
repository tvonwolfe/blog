module Components
  module Posts
    class Tags < Base
      attr_reader :post

      def initialize(post)
        @post = post
      end

      def view_template
        div id: "post-tags" do
          tags.pluck(:value).each do |tag|
            span class: "font-semibold text-slate-400 pr-2 py-1 hover:text-slate-600 dark:hover:text-slate-200 whitespace-nowrap" do
              a href: posts_path(tag:) do
                "##{tag}"
              end
            end
          end
        end
      end

      delegate :tags, to: :post, private: true
    end
  end
end
