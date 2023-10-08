class Ingredient < ApplicationRecord
  belongs_to :recipe
  #食材名、数量必須
  validates :content, :quantity, presence: true
end
