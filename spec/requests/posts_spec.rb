# frozen_string_literal: true

describe "Posts", type: :request do
  describe "GET /posts" do
    let!(:unpublished_posts) { create_list(:post, 3) }
    let!(:published_posts) { create_list(:post, 3, :published) }

    before do
      allow(Views::Posts::Index).to receive(:new).and_call_original
    end

    context "when requesting an HTML response" do
      it "returns a successful HTTP response" do
        get posts_path

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it "renders the correct view" do
        get posts_path

        expect(Views::Posts::Index).to have_received(:new)
      end
    end

    context "when requesting an XML format" do
      it "returns a successful HTTP response" do
        get posts_path(format: :xml)

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it "does not render the Phlex view" do
        expect(Views::Posts::Index).not_to have_received(:new)
      end

      it "returns an XML response" do
        get posts_path(format: :xml)
        expect(response.content_type).to eq "application/xml; charset=utf-8"
      end
    end
  end

  describe "GET /posts/:handle" do
    let!(:unpublished_post) { create(:post) }
    let!(:published_post) { create(:post, :published) }

    before do
      allow(Views::Posts::Show).to receive(:new).and_call_original
    end

    context "when the post is not published" do
      it "redirects to the home page" do
        get post_path(unpublished_post)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
      end
    end

    context "when the post is published" do
      it "returns a successful HTTP response" do
        get post_path(published_post)

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it "renders the post view" do
        get post_path(published_post)

        expect(Views::Posts::Show).to have_received(:new)
          .with(post: having_attributes(class: Post, id: published_post.id))
      end
    end
  end
end
