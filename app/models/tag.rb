class Tag < ApplicationRecord
  has_many :recipe_tag_relations, dependent: :destroy
  has_many :recipes, through: :recipe_tag_relations

  validates :tag_name, presence:true

  def self.search(keyword)
    if keyword.present?
      where('tags.tag_name LIKE ?', '%'+keyword+'%')
    else
      all
    end
  end

  private

end
