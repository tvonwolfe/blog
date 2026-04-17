# frozen_string_literal: true

class PostLinkParserJob < ApplicationJob
  queue_as :default

  def perform(post)
    return unless post.published?

    PostLinkParser.new(post).parse_links
  end
end
