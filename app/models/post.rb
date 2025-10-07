class Post < ApplicationRecord
  include Publishable
  include Taggable

  MAX_TITLE_LENGTH = 140

  before_validation -> { self.handle = to_param if handle.blank? }

  validates :title, presence: true, length: { maximum: MAX_TITLE_LENGTH }
  validates :handle, presence: true, uniqueness: true, length: { maximum: MAX_TITLE_LENGTH }

  scope :titled, ->(title) { where("title ILIKE :title", title: "%#{title}%") }
  scope :display_order, -> { order(published_at: :desc) }

  def to_param = title&.parameterize

  def html_content
    Commonmarker.to_html(content)
  end
end
