# frozen_string_literal: true

class PostLinkParser
  attr_reader :post

  def initialize(post)
    @post = post
  end

  def parse_links
    urls = []
    parsed_content.walk { |node| urls << node.url if node.type == :link }

    existing_links = Link.where(target_url: urls)

    post.transaction do
      post.links = existing_links
      post.save!

      new_urls = urls - existing_links.map(&:target_url).map(&:to_s)

      new_urls.each do |url|
        post.links.create(target_url: url)
      end
    end

    Link.dangling.destroy_all

    post.links
  end

  def parsed_content
    @parsed_content ||= Commonmarker.parse(post.content)
  end
end
