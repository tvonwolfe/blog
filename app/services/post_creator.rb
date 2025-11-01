class PostCreator
  attr_reader :params

  def initialize(params)
    @params = params
    Rails.logger.info(self.class.name) { "params: #{params}" }
  end

  def create_post
    post = Post.new(params.except(:tags))
    post.tags ||= tags

    post.transaction do
      post.save
      post.publish
    end

    post
  end

  private

  def tags
    return if tags_param.blank?

    found_tags = Tag.where(value: tags_param)

    new_tags = (tags_param - found_tags.pluck(:value)).map do |tag_value|
      Tag.new(value: tag_value)
    end

    found_tags + new_tags
  end

  def tags_param = params[:tags]
end
