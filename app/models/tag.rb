class Tag < ApplicationRecord
  has_many :recipe_tag_relations, dependent: :destroy
  # has_and_belongs_to_many :recipes, join_table: :recipe_tag_relations
  has_many :recipes, through: :recipe_tag_relations

  validates :tag_name, presence:true, length:{maximum:50}

  def self.search(keyword)
    if keyword.present?
      where('tags.tag_name LIKE ?', '%'+keyword+'%')
    else
      all
    end
  end

end
