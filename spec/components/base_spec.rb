# frozen_string_literal: true

describe Components::Base, type: :component do
  let(:dummy_component_class) do
    Class.new(described_class) do
      before_template :before_template_callback
      after_template :after_template_callback

      def view_template
        h1 { "Component" }
      end

      def before_template_callback = nil

      def after_template_callback = nil
    end
  end
  let(:component) { dummy_component_class.new }

  describe "callbacks" do
    describe ".before_template" do
      before do
        allow(component).to receive(:before_template_callback).and_call_original
        allow(component).to receive(:view_template).and_call_original
      end

      it "triggers callback before view_template" do
        render component

        expect(component).to have_received(:before_template_callback).ordered
        expect(component).to have_received(:view_template).ordered
      end

      it "does not share callbacks with superclass" do
        expect(dummy_component_class.before_template_actions).not_to eq(described_class.before_template_actions)
      end

      it "shares callbacks with subclasses" do
        subclass = Class.new(dummy_component_class)

        expect(subclass.before_template_actions).to eq dummy_component_class.before_template_actions
      end
    end

    describe ".after_template" do
      before do
        allow(component).to receive(:after_template_callback).and_call_original
        allow(component).to receive(:view_template).and_call_original
      end

      it "triggers callback before view_template" do
        render component

        expect(component).to have_received(:view_template).ordered
        expect(component).to have_received(:after_template_callback).ordered
      end

      it "does not share callbacks with superclass" do
        expect(dummy_component_class.after_template_actions).not_to eq(described_class.after_template_actions)
      end

      it "shares callbacks with subclasses" do
        subclass = Class.new(dummy_component_class)

        expect(subclass.after_template_actions).to eq dummy_component_class.after_template_actions
      end
    end
  end
end
