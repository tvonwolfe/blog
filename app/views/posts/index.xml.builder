# frozen_string_literal: true

xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.feed xmlns: "http://www.w3.org/2005/Atom" do
  xml.id root_url
  xml.title "tvonwolfe"
  xml.updated @posts.first.published_at.iso8601

  xml.author do
    xml.name "tvonwolfe"
    xml.email "me@tvonwolfe.com"
  end

  xml.link href: root_url, rel: :alternate
  xml.link href: feed_url, ref: :self

  @posts.each do |post|
    xml.entry do
      xml.id post_url(post)
      xml.title post.title
      xml.updated post.updated_at.iso8601
      xml.published post.published_at.iso8601
      xml.link href: post_url(post)

      xml.author do
        xml.name "tvonwolfe"
        xml.email "me@tvonwolfe.com"
      end

      post.tags.each do |tag|
        xml.category term: tag.value
      end

      xml.content Views::Posts::Show.new(post:).post_html_content, type: :html
    end
  end
end
