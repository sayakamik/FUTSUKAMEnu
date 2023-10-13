class Procedure < ApplicationRecord
  belongs_to :recipe
  has_one_attached :image
  # 作り方必須
  validates :direction, presence: true

  def get_image(width, height)
    if image.attached?
      image.variant(resize_to_limit: [width, height]).processed
    else
      nil
    end
  end
end
