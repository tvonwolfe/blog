# frozen_string_literal: true

describe Tag, type: :model do
  subject(:tag) { build(:tag) }

  describe "validations" do
    it "is valid from the factory" do
      expect(tag).to be_valid
    end

    it "is invalid when blank" do
      tag.value = ""
      expect(tag).not_to be_valid
    end

    it "is invalid when too long" do
      tag.value = "a" * 65
      expect(tag).not_to be_valid
    end

    it "is invalid when not unique" do
      Tag.create!(value: tag.value)
      expect(tag).not_to be_valid
    end
  end

  describe ".dangling" do
    let(:tagged_post) { create(:post, :tagged) }
    let!(:dangling_tag) { create(:tag) }
    let!(:non_dangling_tag) { tagged_post.tags.first }

    it "includes only tags that are not associated with any posts" do
      expect(described_class.dangling).to contain_exactly(dangling_tag)
    end
  end
end
