class PostTag < ApplicationRecord
  belongs_to :post, touch: true
  belongs_to :tag

  after_destroy_commit :purge_dangling_tags

  def purge_dangling_tags
    Tag.where.missing(:post_tags).destroy_all
  end
end
