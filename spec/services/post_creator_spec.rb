# frozen_string_literal: true

describe PostCreator do
  subject(:post_creator) { described_class.new(params) }

  describe "#create_post" do
    context "when params are missing" do
      let(:params) { {} }

      it "does not create a Post" do
        expect do
          post = post_creator.create_post

          expect(post).not_to be_persisted
        end.not_to change(Post, :count)
      end

      it "returns post with errors" do
        post = post_creator.create_post

        expect(post.errors).to be_present
      end
    end

    context "when params are invalid" do
      let(:params) do
        attributes_for(:post, title: "a" * (Post::MAX_TITLE_LENGTH+1))
      end

      it "does not create a post" do
        expect do
          post = post_creator.create_post

          expect(post).not_to be_persisted
        end.not_to change(Post, :count)
      end

      it "returns post with errors" do
        post = post_creator.create_post
        expect(post.errors[:title].first).to match(/is too long \(maximum is \d+ characters\)/)
      end
    end

    context "when post params are valid" do
      let(:params) { attributes_for(:post) }

      it "persists the post" do
        expect do
          post = post_creator.create_post

          expect(post).to be_persisted
          expect(post.title).to eq params[:title]
          expect(post.content).to eq params[:content]
        end.to change(Post, :count).by(1)
      end

      it "publishes the post" do
        post = post_creator.create_post

        expect(post).to be_published
      end

      context "when tags are included" do
        let(:tags) { [ "tag-a", "tag-b" ] }
        let(:params) { attributes_for(:post).merge(tags:) }

        it "creates post and tags" do
          expect do
            post = post_creator.create_post

            expect(post.tags.pluck(:value)).to eq tags
          end.to change(Post, :count).by(1)
            .and change(PostTag, :count).by(2)
            .and change(Tag, :count).by(2)
        end

        context "when tags are included and Tag records already exist for them" do
          before do
            create(:tag, value: tags.first)
          end

          it "doesn't create Tag records, does create associations" do
            expect do
              post = post_creator.create_post

              expect(post.tags.pluck(:value)).to eq tags
            end.to change(Post, :count).by(1)
              .and change(PostTag, :count).by(2)
              .and change(Tag, :count).by(1)
          end
        end

        context "when post params are invalid" do
          let(:params) { { tags: } }

          it "does not create any tags" do
            expect do
              post_creator.create_post
            end.not_to change(Tag, :count)
          end
        end
      end
    end
  end
end
