# frozen_string_literal: true

RSpec.describe Post do
  subject(:post) { build(:post) }

  describe "validations" do
    it "is valid from the factory" do
      expect(post).to be_valid
    end

    it "is invalid without a title" do
      post.title = nil
      expect(post).not_to be_valid
    end
  end

  describe "handle assignment" do
    it "converts title into a url-friendly handle" do
      post.title = "A Post Which Has a Title"

      expect do
        expect(post).to be_valid
      end.to change(post, :handle).from(nil).to("a-post-which-has-a-title")
    end
  end

  describe "Publishable" do
    describe "#publish!" do
      context "when the post has not been published yet" do
        it "sets the published_at timestamp" do
          expect do
            post.publish!
          end.to change(post, :published_at)

          expect(post.published_at).to be_present
        end
      end

      context "when the post has been published" do
        before do
          post.publish!
        end

        it "does nothing" do
          expect do
            post.publish!
          end.not_to change(post.reload, :published_at)
        end
      end
    end

    describe "#published?" do
      context "when the post is not yet published" do
        it "returns false" do
          expect(post.published?).to be false
        end
      end

      context "when the post has been published" do
        before do
          post.publish!
        end

        it "returns true" do
          expect(post.published?).to be true
        end
      end
    end

    describe "scopes" do
      let!(:published_post) { create(:post, published_at: DateTime.current) }
      let!(:draft_post) { create(:post) }

      describe ".drafted" do
        it "only returns drafted posts" do
          expect(described_class.drafted).to contain_exactly(draft_post)
        end
      end

      describe ".published" do
        it "only returns published posts" do
          expect(described_class.published).to contain_exactly(published_post)
        end
      end
    end
  end

  describe "Taggable" do
    let!(:tagged_post) { create(:post, :tagged) }
    let!(:untagged_post) { create(:post) }

    describe ".tagged" do
      it "only includes posts that have tags" do
        expect(described_class.tagged).to contain_exactly(tagged_post)
      end
    end

    describe ".untagged" do
      it "only includes posts that have no tags" do
        expect(described_class.untagged).to contain_exactly(untagged_post)
      end
    end

    describe ".tagged_with" do
      let(:tag) { create(:tag, value: "a-tag") }
      let(:post_with_tag) { create(:post, tags: [ tag ]) }
      let(:post_with_other_tag) { create(:post, :tagged) }
      let(:post_with_no_tags) { create(:post) }

      it "only includes posts with the specified tag" do
        expect(described_class.tagged_with("a-tag")).to contain_exactly(post_with_tag)
      end
    end
  end
end
