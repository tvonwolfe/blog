# frozen_string_literal: true

RSpec.describe PostLinkParserJob, type: :job do
  let(:url) { Faker::Internet.url }
  let(:content) { "some text #{url} incredible stuff the end" }
  let(:post) { create(:post, content:) }
  let(:post_link_parser) { PostLinkParser.new(post) }

  before do
    allow(PostLinkParser).to receive(:new).with(post).and_return(post_link_parser)
    allow(post_link_parser).to receive(:parse_links).and_call_original
  end

  context "when the post is published" do
    before do
      post.publish
    end

    it "invokes the PostLinkParser service with the given post" do
      described_class.perform_now(post)

      expect(post_link_parser).to have_received(:parse_links)
    end
  end

  context "when the post is not published" do
    it "does nothing" do
      described_class.perform_now(post)

      expect(post_link_parser).not_to have_received(:parse_links)
    end
  end
end
