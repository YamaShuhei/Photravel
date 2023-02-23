# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :comment,
  length: { minimum: 1, maximum: 100 }
end
