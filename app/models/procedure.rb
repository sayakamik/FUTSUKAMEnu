class Procedure < ApplicationRecord
  belongs_to :recipe
  has_one_attached :image
  # 作り方必須
  validates :direction, presence: true
end
