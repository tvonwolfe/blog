# frozen_string_literal: true

class PostLinkParserJob < ApplicationJob
  queue_as :default

  def perform(post)
    PostLinkParser.new(post).parse_links
  end
end
