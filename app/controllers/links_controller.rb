# frozen_string_literal: true

class LinksController < ApplicationController
  def index
    @links = Link
      .includes(:posts)
      .select(:id, :target_domain, :target_url)
      .group(:target_domain, :target_url, :id)
      .order("COUNT(target_domain) DESC, target_url ASC")
  end
end
