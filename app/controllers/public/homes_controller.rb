class Public::HomesController < ApplicationController
  def top
    @recipes = Recipe.where(is_draft: false).limit(4).order("created_at DESC")
    @original_menus = OriginalMenu.all
  end

  def about
  end
end
