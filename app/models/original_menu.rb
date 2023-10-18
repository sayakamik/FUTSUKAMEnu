class OriginalMenu < ApplicationRecord
  has_many :recipes, dependent: :destroy

  def self.search(keyword)
    if keyword.present?
      where('original_menus.name LIKE ?', '%'+keyword+'%')
    else
      all
    end
  end

end
