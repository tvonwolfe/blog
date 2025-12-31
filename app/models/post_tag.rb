# frozen_string_literal: true

class PostTag < ApplicationRecord
  belongs_to :post, touch: true
  belongs_to :tag

  accepts_nested_attributes_for :tag

  after_destroy_commit :purge_dangling_tags

  def purge_dangling_tags
    Tag.where.missing(:post_tags).destroy_all
  end
end
