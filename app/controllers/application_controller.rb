class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Phlex handles layouts - disable the Rails built-in ones
  layout false

  rescue_from ActiveRecord::RecordNotFound, with: -> { redirect_to :root }
end
