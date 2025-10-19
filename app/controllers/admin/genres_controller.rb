class Admin::GenresController < ApplicationController

    before_action :set_genre, only: [:edit, :update]
    def index
        @genres = Genre.all
        @genre = Genre.new
    end

    def create
      @genre = Genre.new(genre_params)

      if @genre.save
        redirect_to admin_genres_path, notice: "ジャンル「#{@genre.name}」を登録しました。"
      else
        @genres =Genre.all
        flash.now[:alert] = "登録に失敗しました"
        render :index
      end
    end

    def edit
        @genre
    end

    def update
        if @genre.update(genre_params)
          redirect_to admin_genres_path, notice: "ジャンル「#{@genre.name}」を更新しました。"
        else
          flash.now[:alert] = "ジャンルの更新に失敗しました。"
          render :edit
        end
      end

    private

    def genre_params
        params.require(:genre).permit(:name)
    end

    def set_genre
        @genre = Genre.find(params[:id])
    end
end
