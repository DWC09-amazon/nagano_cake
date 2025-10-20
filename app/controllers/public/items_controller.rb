class Public::ItemsController < ApplicationController
  def index
    @items = Item.where(is_active: true).order(id: :desc)
    if params[:genre_id].present?
      @items = @items.where(genre_id: params[:genre_id])
      @current_genre = Genre.find(params[:genre_id])
    end
    
    @items_count = @items.count
    @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
  end
end