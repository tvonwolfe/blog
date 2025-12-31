# frozen_string_literal: true

class Tag < ApplicationRecord
  MIN_TAG_LENGTH = 1
  MAX_TAG_LENGTH = 64

  has_many :post_tags, inverse_of: :tag, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :value, presence: true, uniqueness: true, length: { in: MIN_TAG_LENGTH..MAX_TAG_LENGTH }

  default_scope -> { order(value: :asc) }

  scope :dangling, -> { where.missing(:post_tags) }
end
