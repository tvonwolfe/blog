# frozen_string_literal: true

class PostUpdater
  attr_reader :post

  def initialize(post)
    @post = post
  end

  def update(params)
    tags = instantiate_tags(params[:tags])

    post.transaction do
      post.tags = tags
      post.update(params.except(:tags))
      Tag.dangling.destroy_all
    end

    post
  end

  private

  def instantiate_tags(tag_strings)
    return [] if tag_strings.blank?

    found_tags = Tag.where(value: tag_strings)

    new_tags = (tag_strings - found_tags.pluck(:value)).map do |tag_value|
      Tag.new(value: tag_value)
    end

    found_tags + new_tags
  end
end
