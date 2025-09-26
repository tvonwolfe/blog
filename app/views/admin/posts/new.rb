  module Views
    module Admin
      module Posts
        class New < ::Views::Base
          include Phlex::Rails::Helpers::RichTextArea

          def view_template
            render Components::Layout.new(title: "New Post") do
              render Components::Posts::Form
            end
          end
        end
      end
    end
  end
