# frozen_string_literal: true

describe PostUpdater do
  let(:post) { create(:post) }
  let(:params) { attributes_for(:post) }

  subject(:post_updater) { described_class.new(post) }

  it "updates the post with new attributes" do
    expect do
      post_updater.update(params)
    end.to change { post.reload.updated_at }
      .and change { post.title }
      .and change { post.content }
  end

  it "enqueues a PostLinkParserJob" do
    post_updater.update(params)

    expect(PostLinkParserJob).to have_been_enqueued.with(post)
  end

  context "when params are invalid" do
    let(:params) { { title: "a" * (Post::MAX_TITLE_LENGTH + 1) } }

    it "does not update the post" do
      expect do
        post_updater.update(params)
      end.not_to change { post.reload.updated_at }
    end

    it "does not enqueue a PostLinkParserJob" do
      expect do
        post_updater.update(params)
      end.not_to have_enqueued_job(PostLinkParserJob)
    end
  end

  context "when tags are included" do
    let(:tags) { [ "tag-a", "tag-b" ] }
    let(:params) { { tags: } }

    it "creates tag records and associations" do
      expect do
        post_updater.update(params)
      end.to change { post.reload.updated_at }
        .and change { post.tags.pluck(:value) }.from([]).to(tags)
        .and change(Tag, :count).by(2)
        .and change(PostTag, :count).by(2)
    end

    context "when tag records already exist for the given params" do
      before do
        create(:tag, value: tags.first)
      end

      it "only creates Tag record for values that don't exist yet" do
        expect do
          post_updater.update(params)
        end.to change { post.reload.updated_at }
        .and change { post.tags.pluck(:value) }.from([]).to(tags)
        .and change(Tag, :count).by(1)
        .and change(PostTag, :count).by(2)
      end
    end

    context "when tags are removed from the post" do
      let!(:post) { create(:post, :tagged) }
      let(:post_tag) { post.post_tags.first }
      let(:old_tag) { post_tag.tag }
      let(:old_tags) { [ post_tag.tag.value ] }
      let(:new_tags) { [ "tag-1" ] }
      let(:params) { { tags: new_tags } }

      it "destroys tag associations" do
        expect do
          post_updater.update(params)
        end.to change { PostTag.exists?(post_tag.id) }.from(true).to(false)
          .and change { post.tags.pluck(:value) }.from(old_tags).to(new_tags)
      end

      context "when removed tag is orphaned" do
        it "also destroys the tag record" do
          expect do
            post_updater.update(params)
          end.to change { Tag.exists?(old_tag.id) }.from(true).to(false)
        end
      end

      context "when removed tag is not orphaned" do
        let!(:other_post) do
          post = create(:post)
          post.tags << old_tag

          post
        end

        it "does not destroy the removed tag" do
          expect do
            post_updater.update(params)
          end.not_to change { Tag.exists?(old_tag.id) }
        end
      end
    end
  end

  context "when `publish` param is present" do
    let(:params) { { publish: } }

    context "when param value is falsy" do
      let(:publish) { nil }

      it "doesn't publish the post" do
        expect do
          post_updater.update(params)
        end.not_to change { post.reload.published? }
      end
    end

    context "when the param value is truthy" do
      let(:publish) { true }

      context "when the post isn't published" do
        it "publishes the post" do
          expect do
            post_updater.update(params)
          end.to change { post.reload.published? }.from(false).to(true)
        end
      end

      context "when the post is already published" do
        before do
          post.publish!
        end

        it "doesn't alter the state of the post" do
          expect do
            post_updater.update(params)
          end.not_to change { post.reload.published? }
        end
      end
    end
  end

  context "when `unpublish` param is present" do
    let(:params) { { unpublish: } }

    context "when param value is falsy" do
      let(:unpublish) { nil }

      it "doesn't unpublish the post" do
        expect do
          post_updater.update(params)
        end.not_to change { post.reload.published? }
      end
    end

    context "when the param value is truthy" do
      let(:unpublish) { true }

      context "when the post isn't published" do
        it "doesn't alter the state of the post" do
          expect do
            post_updater.update(params)
          end.not_to change { post.reload.published? }
        end
      end

      context "when the post is published" do
        before do
          post.publish!
        end

        it "unpublishes the post" do
          expect do
            post_updater.update(params)
          end.to change { post.reload.published? }.from(true).to(false)
        end
      end
    end
  end
end
