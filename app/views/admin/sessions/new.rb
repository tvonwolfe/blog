module Views
  module Admin
    module Sessions
      class New < Base
        include Phlex::Rails::Helpers::FormAuthenticityToken

        def view_template
          render Components::Admin::Layout.new(header: false) do
            div class: "mt-8 h-full" do
              form action: admin_sessions_path, method: "post", class: "flex flex-col mx-auto max-w-[20rem]" do
                label for: "password", class: "font-bold" do
                  "Password"
                end
                input id: :password, name: "session[password]", type: :password, class: "p-2 border border-stone-200"
                form_authenticity_token
                input type: :submit, class: "mt-4 p-2 rounded text-slate-200 bg-[#141c2b] hover:cursor-pointer", value: "Log In"
              end
            end
          end
        end
      end
    end
  end
end
