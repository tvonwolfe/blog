# frozen_string_literal: true

describe Link, type: :model do
  let(:link) { build(:link) }

  describe "validations" do
    it "is valid from the factory" do
      expect(link).to be_valid
    end

    context "when the link is external" do
      it "automatically assigns a target_domain based on the target_url" do
        new_link = described_class.new(target_url: "https://example.com/this/is-a/pathname")
        expect(new_link).to be_valid

        expect(new_link.target_domain).to eq "example.com"
      end
    end

    context "when the link is internal" do
      let(:link) { build(:link, target_url: "/about") }

      it "is valid without target_domain" do
        expect(link).to be_valid
      end
    end
  end

  describe "normalizations" do
    it "normalizes the target_url value" do
      tag = described_class.new(target_url: "       https://example.com/random       ")

      expect(tag.target_url.to_s).to eq "https://example.com/random"
    end
  end

  describe ".dangling" do
    let(:post_with_link) { create(:post, :with_link) }
    let!(:dangling_link) { create(:link) }
    let!(:non_dangling_link) { post_with_link.links.first }

    it "includes only links that are not associated with any posts" do
      expect(described_class.dangling).to contain_exactly(dangling_link)
    end
  end

  describe ".internal" do
    let!(:external_link) { create(:link, target_url: Faker::Internet.url) }
    let!(:internal_link) { create(:link, target_url: "/about") }

    it "only includes internal links" do
      expect(described_class.internal).to contain_exactly(internal_link)
    end
  end

  describe ".external" do
    let!(:external_link) { create(:link) }
    let!(:internal_link) { create(:link, target_url: "/about") }

    it "only includes external links" do
      expect(described_class.external).to contain_exactly(external_link)
    end
  end

  describe "#internal?" do
    context "when the link is internal" do
      let(:link) { build(:link, target_url: "/about") }

      it "returns true" do
        expect(link.internal?).to be true
      end
    end

    context "when the link is external" do
      let(:link) { build(:link) }

      it "returns false" do
        expect(link.internal?).to be false
      end
    end
  end

  describe "#external?" do
    context "when the link is internal" do
      let(:link) { build(:link, target_url: "/about") }

      it "returns false" do
        expect(link.external?).to be false
      end
    end

    context "when the link is external" do
      let(:link) { build(:link) }

      it "returns true" do
        expect(link.external?).to be true
      end
    end
  end
end
