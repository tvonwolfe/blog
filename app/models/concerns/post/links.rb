# frozen_string_literal: true

class Post
  module Links
    extend ActiveSupport::Concern

    included do
      has_many :post_links, inverse_of: :post, dependent: :destroy
      has_many :links, through: :post_links
    end
  end
end
