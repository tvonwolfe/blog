# frozen_string_literal: true

module Components
  module Admin
    class Header < Base
      def view_template
        div class: "bg-slate-200 dark:bg-zinc-800 text-slate-800 dark:text-zinc-100 px-4 py-2 flex justify-between" do
          div do
            p { "Admin" }
          end
          form action: logout_admin_sessions_path, method: :post do
            input type: :submit, class: "hover:cursor-pointer underline", value: "Log Out"
          end
        end
      end
    end
  end
end
