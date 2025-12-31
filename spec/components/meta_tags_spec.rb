# frozen_string_literal: true

describe Components::MetaTags, type: :component do
  let(:meta_tags_component) { described_class.new }

  describe "#add" do
    it "appends passed meta data as a plain Hash" do
      meta_tags_component.add charset: "utf-8"

      expect(meta_tags_component.data).to eq([ { charset: "utf-8" } ])
    end

    context "when no arguments are passed" do
      it "does nothing" do
        meta_tags_component.add

        expect(meta_tags_component.data).to eq([])
      end
    end
  end

  describe "#view_template" do
    let(:output) { render meta_tags_component }

    context "when there is data present" do
      let(:meta_tags_component) { described_class.new([ { foo: "bar", name: "john" }, { charset: "utf-8" } ]) }

      it "renders each object as a <meta> tag" do
        expect(output).to eq <<~HTML.strip
          <meta foo="bar" name="john"><meta charset="utf-8">
        HTML
      end
    end

    context "when there is no data present" do
      it "renders nothing" do
        expect(output).to eq ""
      end
    end
  end
end
