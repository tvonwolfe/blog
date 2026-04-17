# frozen_string_literal: true

class Link < ApplicationRecord
  normalizes :target_url, with: ->(url) { url.strip }

  serialize :target_url, coder: URLCoder

  has_many :post_links, inverse_of: :link, dependent: :destroy
  has_many :posts, through: :post_links

  before_validation :set_target_domain, on: :create

  validates :target_url, presence: true, uniqueness: true
  validates :target_domain, presence: true

  scope :dangling, -> { where.missing(:post_links) }

  private

  def set_target_domain
    self.target_domain ||= target_url&.host
  end
end
