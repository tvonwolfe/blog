# frozen_string_literal: true

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
            render errors

            form action: form_action, method: form_method, class: "w-full" do
              form_authenticity_token
              input_with_label :title, post.title
              input_with_label :tags, post.tags.pluck(:value).join(" ")

              div class: "flex flex-col mt-6" do
                marksmith_tag "post[content]", value: post.content
              end

              div class: "my-4" do
                div class: "flex gap-1" do
                  id = "publish"
                  checkbox_params = { id:, name: "post[#{id}]" }
                  checkbox_params = checkbox_params.merge(checked: "true", disabled: "true") if post.published?
                  input type: :checkbox, **checkbox_params
                  label for: id do
                    post.published? ? "Published" : "Publish"
                  end
                end
              end

              div class: "flex justify-end gap-2" do
                input type: :submit, class: "w-full sm:w-auto mt-4 p-2 px-6 rounded-sm text-slate-100 bg-slate-700 hover:bg-slate-600 hover:cursor-pointer dark:bg-zinc-500 dark:hover:bg-zinc-600", value: "Save"
              end
            end
            if post.published?
              form action: form_action, method: form_method, class: "w-full flex justify-end" do
                form_authenticity_token
                input type: :hidden, id: "unpublish", name: "post[unpublish]", value: "true"
                input type: :submit, class: "w-full sm:w-auto mt-4 p-2 px-6 rounded-sm text-stone-50 bg-red-900 hover:bg-red-950 hover:cursor-pointer", value: "Unpublish"
              end
            end
          end
        end

        private

        def errors = Components::ErrorList.new(post.errors)

        def input_with_label(id, value)
          label_value = id.to_s.capitalize
          name = "#{post.class.name.downcase}[#{id}]"

          div class: "flex flex-col mb-4" do
            label for: id, class: "font-bold" do
              label_value
            end
            input id: id, name:, value:, class: "rounded-sm border border-slate-300 dark:border-zinc-400 p-1"
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
