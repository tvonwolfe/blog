# frozen_string_literal: true

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:dc": "http://purl.org/dc/elements/1.1", "xmlns:content": "http://purl.org/rss/1.0/modules/content/", "xmlns:atom": "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "tvonwolfe"
    xml.link root_url
    xml.description "A blog by some guy on the Internet"
    xml.lastBuildDate @posts.first.published_at.to_fs(:rfc822) if @posts.first.present?

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link post_url(post)
        xml.guid post_url(post)
        xml.pubDate post.published_at.to_fs(:rfc822)
        xml.tag! "content:encoded", Views::Posts::Show.new(post:).post_html_content
      end
    end
  end
end
