# frozen_string_literal: true

class PostTag < ApplicationRecord
  belongs_to :post, touch: true
  belongs_to :tag

  accepts_nested_attributes_for :tag
end
