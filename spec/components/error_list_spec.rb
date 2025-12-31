# frozen_string_literal: true

describe Components::ErrorList, type: :component do
  subject(:rendered_fragment) { render_fragment described_class.new(error_objects) }

  context "when errors is blank" do
    let(:error_objects) { [] }

    it "renders nothing" do
      expect(rendered_fragment.children).to be_empty
    end
  end

  context "when errors are present" do
    let(:error_objects) { 3.times.map { |i| double(full_message: "Something bad happened #{i}") } }

    it "renders each error message" do
      rendered_errors = rendered_fragment.css("ul").css("li")
      expect(rendered_errors.size).to eq error_objects.size
      expect(rendered_errors.map(&:text)).to all(match(/Something bad happened \d/))
    end
  end
end
