module Components
  module Admin
    module Posts
      class Form < Base
        include Phlex::Rails::Helpers::FormAuthenticityToken

        attr_reader :post

        def initialize(post:)
          @post = post
        end

        def view_template
          div class: "w-full" do
            form action: form_action, method: form_method, class: "w-full" do
              form_authenticity_token
              input_with_label label: "Title", id: :title, value: post.title
              input_with_label label: "Tags", id: :tags, value: post.tags.pluck(:value).join(", ")

              div class: "flex flex-col" do
                label for: "post-content", class: "font-bold" do
                  "Markdown Content"
                end
                textarea id: "post-content", name: "post[content]", class: "w-full border border-slate-300 p-1 rounded-sm min-h-[42rem]" do
                  post.content
                end
              end
              div class: "flex justify-end" do
                input type: :submit, class: "w-full sm:w-auto mt-4 p-2 px-6 rounded-sm text-slate-100 bg-slate-700 hover:bg-slate-600 hover:cursor-pointer", value: "Save"
              end
            end
          end
        end

        private

        def input_with_label(**params)
          label_name = params[:label]
          input_id = params[:id]
          input_type = params[:type]
          value = params[:value]
          name = "#{post.class.name.downcase}[#{input_id}]"

          div class: "flex flex-col mb-4" do
            label for: input_id, class: "font-bold" do
              label_name
            end
            input id: input_id, name: name, type: input_type, value: value, class: "rounded-sm border border-slate-300 p-1"
          end
        end

        def form_method
          if post.persisted?
            :put
          else
            :post
          end
        end

        def form_action
          if post.persisted?
            admin_post_path(post)
          else
            admin_posts_path(post)
          end
        end
      end
    end
  end
end
