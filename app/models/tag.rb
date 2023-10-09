class Tag < ApplicationRecord
  has_many :recipe_tag_relations, dependent: :destroy
  has_many :recipes, through: :recipe_tag_relation
end
