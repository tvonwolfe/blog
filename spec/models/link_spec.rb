# frozen_string_literal: true

describe Link, type: :model do
  let(:link) { build(:link) }

  describe "validations" do
    it "is valid from the factory" do
      expect(link).to be_valid
    end

    it "is invalid without a target_url" do
      link.target_url = nil

      expect(link).not_to be_valid
    end

    it "automatically assigns a target_domain based on the target_url" do
      new_link = described_class.new(target_url: "https://example.com/this/is-a/pathname")
      expect(new_link).to be_valid

      expect(new_link.target_domain).to eq "example.com"
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
end
