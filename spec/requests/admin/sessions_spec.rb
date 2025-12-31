# frozen_string_literal: true

describe "Admin::Sessions", type: :request do
  describe "POST /create" do
    before do
      allow(Rails.application.credentials).to receive(:admin_password).and_return("test1234")
    end

    context "when password param provided" do
      let(:params) { {  session: { password: password_param } } }

      context "when password is correct" do
        let(:password_param) { "test1234" }

        it "returns HTTP 302 status" do
          post admin_sessions_path, params: params

          expect(response).to have_http_status(:found)
        end

        it "redirects to admin dashboard" do
          post admin_sessions_path, params: params

          expect(response).to redirect_to(admin_posts_path)
        end
      end

      context "when password is incorrect" do
        let(:password_param) { "wrong1234" }

        before do
          allow(Views::Admin::Sessions::New).to receive(:new).and_call_original
        end

        it "returns HTTP 400 status" do
          post admin_sessions_path, params: params

          expect(response).not_to be_successful
          expect(response).to have_http_status(:bad_request)
        end

        it "renders the login page" do
          post admin_sessions_path, params: params

          expect(Views::Admin::Sessions::New).to have_received(:new)
        end
      end
    end

    context "when password is not provided" do
      before do
        allow(Views::Admin::Sessions::New).to receive(:new).and_call_original
      end

      it "returns HTTP 400 status" do
        post admin_sessions_path

        expect(response).not_to be_successful
        expect(response).to have_http_status(:bad_request)
      end

      it "renders the login page" do
        post admin_sessions_path

        expect(Views::Admin::Sessions::New).to have_received(:new)
      end
    end
  end

  describe "GET /new" do
    before do
      allow(Views::Admin::Sessions::New).to receive(:new).and_call_original
    end

    it "returns http success" do
      get "/admin/sessions/new"
      expect(response).to have_http_status(:success)
    end

    it "renders the correct view" do
      get new_admin_session_path
      expect(Views::Admin::Sessions::New).to have_received(:new)
    end
  end
end
