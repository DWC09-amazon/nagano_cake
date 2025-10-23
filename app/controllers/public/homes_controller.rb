class Public::HomesController < ApplicationController
  def top
    @new_items = Item.where(is_active: true).order(id: :desc).limit(4)
    @genres = Genre.all
  end

  def about
  end
end
