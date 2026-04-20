def target_url(link)
  return link.target_url unless link.internal?

  URI.parse(root_url).tap do |uri|
    uri.path = link.target_url.to_s
  end
end

json.array! @link_domains.each do |link_domain|
  domain = link_domain.target_domain
  json.domain domain || URI.parse(root_url).host
  domain_links = @links.select { |link| link.target_domain == domain }
  json.count link_domain.domain_freq

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
