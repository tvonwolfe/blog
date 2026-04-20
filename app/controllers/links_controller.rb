# frozen_string_literal: true

class LinksController < ApplicationController
  def index
    @link_domains = Link
      .select(:target_domain, "COUNT(target_domain IS NULL) as domain_freq")
      .group(:target_domain)
      .order("domain_freq DESC, target_domain ASC")

    @links = Link.includes(:posts).select(:id, :target_domain, :target_url)
  end
end
