def target_url(link)
  return link.target_url unless link.internal?

  URI.parse(root_url).tap do |uri|
    uri.path = link.target_url.to_s
  end
end

json.array! @links.pluck(:target_domain).uniq do |domain|
  json.domain domain || root_url
  domain_links = @links.select { |link| link.target_domain == domain }
  json.count domain_links.count

  json.links do
    domain_links.each do |domain_link|
      domain_link.posts.each do |post|
        target_url = target_url(domain_link)

        json.child! do
          json.sourceUrl post_url(post)
          json.targetUrl target_url
        end
      end
    end
  end
end
