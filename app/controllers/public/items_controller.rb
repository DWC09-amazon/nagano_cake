class Public::ItemsController < ApplicationController
  def index
    @genres = Genre.all
    
    base_items = Item.where(is_active: true).order(id: :desc)
    
    if params[:genre_id].present?
      @current_genre = Genre.find(params[:genre_id])
      
      @items = base_items.where(genre_id: params[:genre_id])
      @items_count = @items.count 
    else
      @items = base_items
      @items_count = base_items.count
    end

    @items = @items.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
  end
end