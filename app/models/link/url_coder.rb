class Link
  class URLCoder
    def self.load(url_string)
      return if url_string.blank?

      URI.parse(url_string)
    end

    def self.dump(uri)
      uri.to_s
    end
  end
end
