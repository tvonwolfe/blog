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

    def publish
      publish!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error(self.class.name) { "Failed to publish post: #{e.message}" }
      false
    end

    def published? = published_at.present?
  end
end
