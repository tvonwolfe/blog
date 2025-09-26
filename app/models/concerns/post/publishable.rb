class Post
  module Publishable
    extend ActiveSupport::Concern

    included do
      scope :drafted, -> { where(published_at: nil) }
      scope :published, -> { where.not(published_at: nil) }
    end

    def publish!
      update!(published_at: DateTime.current) unless published?
    end

    def published? = published_at.present?
  end
end
