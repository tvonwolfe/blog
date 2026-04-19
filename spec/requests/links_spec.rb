# frozen_string_literal: true

describe "Links", type: :request do
  describe "GET /.well-known/links" do
    let(:post) { create(:post) }
    let(:linked_post) { create(:post) }
    let!(:external_link) { create(:link, posts: [post], target_url: "https://abc.xyz/first") }
    let!(:internal_link) { create(:link, target_url: post_path(linked_post), posts: [post]) }
    let!(:second_external_link_same_domain) { create(:link, target_url: "https://abc.xyz/second", posts: [linked_post]) }

    it "returns the expected data in the correct format" do
      get links_path

      expect(response.parsed_body.map(&:deep_symbolize_keys)).to eq([
        {
          domain: external_link.target_domain,
          count: 2,
          links: [
            {
              targetUrl: external_link.target_url.to_s,
              sourceUrl: post_url(post)
            },
            {
              targetUrl: second_external_link_same_domain.target_url.to_s,
              sourceUrl: post_url(linked_post)
            }
          ]
        },
        {
          domain: root_url,
          count: 1,
          links: [
            {
              targetUrl: post_url(linked_post),
              sourceUrl: post_url(post)
            }
          ]
        }
      ])
    end
  end
end
