module Components
  class Errors < Base
    attr_reader :errors

    def initialize(errors)
      @errors = errors
    end

    def view_template
      div class: "w-full my-2 rounded-sm px-2 py-4 border border-red-600 bg-red-50 text-red-700" do
        ul do
          errors.each do |error|
            li do
              error.full_message
            end
          end
        end
      end
    end
  end
end
