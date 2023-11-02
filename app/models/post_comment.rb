class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :comment, presence: true, length: { in: 1..150 }
end
