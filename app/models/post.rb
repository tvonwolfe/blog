# frozen_string_literal: true

class Post < ApplicationRecord
  include Publishable
  include Taggable
  include Links

  MAX_TITLE_LENGTH = 140

  normalizes :title, with: ->(title) { title.strip }

  before_validation -> { self.handle ||= to_param }

  validates :title, presence: true, length: {maximum: MAX_TITLE_LENGTH}
  validates :handle, presence: true, uniqueness: true, length: {maximum: MAX_TITLE_LENGTH}
  validates :content, presence: true

  scope :titled, ->(title) { where("title ILIKE :title", title: "%#{title}%") }
  scope :display_order, -> { order(published_at: :desc) }

  def to_param = handle || title&.parameterize
end
