# frozen_string_literal: true

#
def rss_description(post)
  match_data = post.html_content.match(%r{<p>(.*)</p>})
  return unless match_data

  match_data[1]
end

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
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
        xml.description rss_description(post)
      end
    end
  end
end
