# frozen_string_literal: true

describe "Admin::Posts", type: :request do
  describe "GET /admin/posts" do
    let(:view_class) { Views::Admin::Posts::Index }

    before do
      allow(view_class).to receive(:new).and_call_original
    end

    context "when not logged in" do
      it "redirects to root path" do
        get admin_posts_path

        expect(response).to redirect_to :root
      end
    end

    context "when logged in" do
      before { set_auth_cookie! }

      it "responds with the correct status" do
        get admin_posts_path

        expect(response).to be_successful
        expect(response).to have_http_status(:ok)
      end

      it "renders the correct view" do
        get admin_posts_path

        expect(view_class).to have_received(:new)
      end
    end
  end

  describe "POST /admin/posts" do
    let(:tags) { [ "tag-1", "tag-2" ] }
    let(:params) do
      {
        post: {
          title: "A Post With a Title",
          content: "# H1 Tag\nregular stuff\n\n",
          tags: tags.join(" ")
        }
      }
    end

    context "when not logged in" do
      it "redirects back to root path" do
        post admin_posts_path, params: params

        expect(response).to redirect_to(:root)
      end

      it "does not create a new post" do
        expect do
          post admin_posts_path, params: params
        end.not_to change(Post, :count)
      end
    end

    context "when logged in" do
      before { set_auth_cookie! }

      it "redirects to the newly created post" do
        post admin_posts_path, params: params

        expect(response).to redirect_to(/\/posts\/a-post-with-a-title/)
      end

      it "calls the correct service to create the post" do
        post admin_posts_path, params: params
      end

      it "persists post and tags" do
        expect do
          post admin_posts_path, params: params
        end.to change(Post, :count).by(1)
          .and change(PostTag, :count).by(2)
          .and change(Tag, :count).by(2)
      end

      context "when a tag already exists" do
        before do
          create(:tag, value: tags.first)
        end

        it "creates the correct number of records and associations" do
          expect do
            post admin_posts_path, params: params
          end.to change(Post, :count).by(1)
            .and change(PostTag, :count).by(2)
            .and change(Tag, :count).by(1)
        end
      end

      context "when `post` param is missing" do
        let(:params) { {} }

        it "returns a 400 status" do
          post admin_posts_path, params: params

          expect(response).not_to be_successful
          expect(response).to have_http_status(:bad_request)
        end

        it "does not create a Post" do
          expect do
            post admin_posts_path, params: params
          end.not_to change(Post, :count)
        end
      end

      context "when required post params are missing" do
        let(:view_class) { Views::Admin::Posts::New }
        let(:params) do
          {
            post: {
              content: "Some content"
            }
          }
        end

        before do
          allow(view_class).to receive(:new).and_call_original
        end

        it "returns a 422 response" do
          post admin_posts_path, params: params

          expect(response).not_to be_successful
          expect(response).to have_http_status(:unprocessable_content)
        end

        it "renders the correct view" do
          post admin_posts_path, params: params

          expect(Views::Admin::Posts::New).to have_received(:new).with(post: instance_of(Post))
        end
      end
    end
  end

  describe "GET /admin/posts/:id/edit" do
    let(:post) { create(:post) }
    let(:view_class) { Views::Admin::Posts::Edit }

    before do
      allow(view_class).to receive(:new).and_call_original
    end

    context "when not logged in" do
      it "redirects to root path" do
        get edit_admin_post_path(post)

        expect(response).to redirect_to(:root)
      end
    end

    context "when logged in" do
      before { set_auth_cookie! }

      it "renders the correct view" do
        get edit_admin_post_path(post)

        expect(view_class).to have_received(:new)
        .with(post: having_attributes(class: Post, id: post.id))
      end

      context "when the post is not found" do
        it "redirects back to /admin/posts" do
          get edit_admin_post_path(30_000)

          expect(response).to redirect_to(admin_posts_path)
        end
      end
    end
  end

  describe "PUT /admin/posts/:id" do
    let(:post) { create(:post) }
    let(:params) do
      {
        post: {
          title: "A New Title"
        }
      }
    end
    let(:view_class) { Views::Admin::Posts::Edit }

    before do
      allow(view_class).to receive(:new).and_call_original
    end

    context "when not logged in" do
      it "redirects to root path" do
        put admin_post_path(post), params: params

        expect(response).to redirect_to(:root)
      end

      it "doesn't update the post" do
        expect do
          put admin_post_path(post), params: params
        end.not_to change { post.reload.title }
      end
    end

    context "when logged in" do
      before { set_auth_cookie! }

      it "redirects to admin posts path" do
        put admin_post_path(post), params: params

        expect(response).to redirect_to(admin_posts_path)
      end

      it "updates the post" do
        expect do
          put admin_post_path(post), params: params
        end.to change { post.reload.title }
          .and change { post.updated_at }
      end

      context "when params are invalid" do
        let(:params) do
          {
            post: {
              title: nil
            }
          }
        end

        it "returns a 422 status code" do
          put admin_post_path(post), params: params

          expect(response).to have_http_status(:unprocessable_content)
        end

        it "renders the edit view with the post" do
          put admin_post_path(post), params: params

          expect(view_class).to have_received(:new)
            .with(post: having_attributes(class: Post, id: post.id))
        end
      end
    end
  end

  describe "GET /admin/posts/new" do
    let(:view_class) { Views::Admin::Posts::New }

    before do
      allow(view_class).to receive(:new).and_call_original
    end

    context "when not logged in" do
      it "redirects to root path" do
        get new_admin_post_path

        expect(response).to redirect_to(:root)
      end
    end

    context "when logged in" do
      before { set_auth_cookie! }

      it "responds successfully" do
        get new_admin_post_path

        expect(response).to have_http_status(:ok)
      end

      it "renders the correct view" do
        get new_admin_post_path

        expect(view_class).to have_received(:new)
      end
    end
  end
end
