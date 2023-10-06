class OriginalMenu < ApplicationRecord
  has_many :recipes, dependent: :destroy
end
