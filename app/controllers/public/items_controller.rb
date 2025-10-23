class Public::ItemsController < ApplicationController
  def index
    @items = Item.where(is_active: true).order(id: :desc)
    
    if params[:genre_id].present?
      @items = @items.where(genre_id: params[:genre_id])
      @current_genre = Genre.find(params[:genre_id])
    end

    @items = @items.page(params[:page]).per(8)
    
    if params[:genre_id].present?
      @items_count = @items.total_count
    else
      @items_count = Item.where(is_active: true).count
    end

    @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
  end
end