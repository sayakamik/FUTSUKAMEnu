class Recipe < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :procedures, dependent: :destroy
  has_many :recipe_tag_relations, dependent: :destroy
  has_many :tags, dependent: :destroy

  belongs_to :original_menu

end
