class Admin::GenresController < ApplicationController

    before_action :authenticate_admin!

    def index
    end

    def show
    end

    def edit
    end

    def update
    end

    private

    def genre_params
        params.require(:genre).permit(:name)
    end
end
