# frozen_string_literal: true

module Components
  module Callbacks
    extend ActiveSupport::Concern

    CALLBACK_TYPES = %i[before after].freeze

    included do
      CALLBACK_TYPES.each do |callback_type|
        class_attribute_name = "#{callback_type}_template_actions".to_sym

        class_attribute class_attribute_name, instance_predicate: false, default: []

        class_eval <<~RUBY
          def self.#{callback_type}_template(*new_actions)
            current_value = public_send(:#{class_attribute_name})
            setter_method = :#{class_attribute_name}=

            # equivalent to `self.*_template_actions += new_actions`
            public_send(setter_method, current_value + new_actions)
          end
        RUBY

        define_method "#{callback_type}_template".to_sym do |&block|
          self.class.public_send(class_attribute_name).each do |action|
            case action
            when Proc
              instance_exec(&action)
            when Symbol
              method(action).call
            end
          end

          super(&block)
        end
      end
    end
  end
end
