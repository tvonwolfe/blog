# frozen_string_literal: true

describe PostLinkParser do
  describe "#parse_links" do
    let(:post_link_parser) { described_class.new(post) }

    context "when a post is newly created" do
      context "when it doesn't contain any URLs" do
        let(:post) { create(:post) }

        it "doesn't create any Link records" do
          expect do
            post_link_parser.parse_links
          end.not_to change(Link, :count)
        end
      end

      context "when it does contain a URL" do
        let(:url) { Faker::Internet.url }
        let(:content) { "some text #{url} incredible stuff the end" }
        let(:post) { create(:post, content:) }

        context "when no Link record exists for the URL" do
          it "creates a new Link record" do
            expect do
              links = post_link_parser.parse_links

              expect(links.first.target_url.to_s).to eq url
            end.to change(Link, :count).by 1
          end

          it "creates a new PostLink record" do
            expect do
              post_link_parser.parse_links
            end.to change(PostLink, :count).by 1
          end
        end

        context "when a Link record already exists for the URL" do
          before do
            create(:link, target_url: url)
          end

          it "does not create another Link record" do
            expect do
              post_link_parser.parse_links
            end.not_to change(Link, :count)
          end

          it "creates a new PostLink record" do
            expect do
              post_link_parser.parse_links
            end.to change(PostLink, :count).by 1
          end
        end

        it "associates the Link with the given post" do
          links = post_link_parser.parse_links

          expect(links.first.posts).to contain_exactly(post)
        end
      end
    end

    context "when an existing post is updated" do
      context "when a link is added" do
        let!(:post) { create(:post) }
        let(:url) { Faker::Internet.url }

        before do
          post.content << "\n#{url}\n"
          post.save
        end

        context "when no Link record exists for the URL" do
          it "creates a new Link record" do
            expect do
              links = post_link_parser.parse_links

              expect(links.first.target_url.to_s).to eq url
            end.to change(Link, :count).by 1
          end

          it "creates a new PostLink record" do
            expect do
              post_link_parser.parse_links
            end.to change(PostLink, :count).by 1
          end
        end

        context "when a Link record already exists for the URL" do
          before do
            create(:link, target_url: url)
          end

          it "does not create another Link record" do
            expect do
              post_link_parser.parse_links
            end.not_to change(Link, :count)
          end

          it "creates a new PostLink record" do
            expect do
              post_link_parser.parse_links
            end.to change(PostLink, :count).by 1
          end
        end

        it "associates the Link with the given post" do
          links = post_link_parser.parse_links

          expect(links.first.posts).to contain_exactly(post)
        end
      end

      context "when a link is removed" do
        let(:url) { Faker::Internet.url }
        let(:content) { "some text incredible stuff the end" }
        let(:post) { create(:post, content:) }
        let!(:link) { create(:link, target_url: url, posts: [post]) }

        it "destroys the association between the post and the link" do
          expect do
            post_link_parser.parse_links
          end.to change { post.reload.links.to_a }.from([link]).to([])
        end

        context "when there are no other posts that include the link" do
          it "destroys the Link record" do
            expect do
              post_link_parser.parse_links
            end.to change { Link.exists?(link.id) }.from(true).to(false)
          end
        end

        context "when there are other posts that include the link" do
          before do
            create(:post, links: [link])
          end

          it "doesn't destroy the Link record" do
            expect do
              post_link_parser.parse_links
            end.not_to change(Link, :count)
          end
        end
      end

      context "when links are neither added nor removed" do
        let(:url) { Faker::Internet.url }
        let(:content) { "\n#{url}\n" }
        let(:post) { create(:post, content:) }
        let!(:link) { create(:link, target_url: url, posts: [post]) }

        it "doesn't destroy or create any Links" do
          expect do
            post_link_parser.parse_links
          end.not_to change(Link, :count)
        end

        it "doesn't destroy or create any PostLinks" do
          expect do
            post_link_parser.parse_links
          end.not_to change(PostLink, :count)
        end

        it "maintains the existing association" do
          expect(post.links).to contain_exactly(link)
          post_link_parser.parse_links

          expect(post.reload.links).to contain_exactly(link)
        end
      end
    end
  end
end
