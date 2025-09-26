class Post
  module Taggable
    extend ActiveSupport::Concern

    included do
      has_many :post_tags, inverse_of: :post, dependent: :destroy
      has_many :tags, through: :post_tags

      scope :tagged, -> { where.associated(:post_tags).distinct }
      scope :untagged, -> { where.missing(:post_tags) }

      scope :tagged_with, ->(tag_values) { tagged.joins(post_tags: :tag).where(tag: { value: Array(tag_values) }) }
    end
  end
end
