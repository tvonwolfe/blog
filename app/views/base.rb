# frozen_string_literal: true

module Views
  class Base < Components::Base
    # The `Views::Base` is an abstract class for all your views.

    # By default, it inherits from `Components::Base`, but you
    # can change that to `Phlex::HTML` if you want to keep views and
    # components independent.

    # TODO: refactor so that the 'layout' is rendered automatically, add a
    # `PageContext` class to bundle up things like meta tags data, page title,
    # etc.
    # use `around_layout` callback to render layout
  end
end
