class MilkshakesController < ApplicationController
    before_action :authenticate_user!
    
    def index
        if params[:search] && !params[:search].empty?
            @milkshakes = Milkshake.where(name: params[:search])
        else
            @milkshakes = Milkshake.all
        end
    end

    def show
        @milkshake = Milkshake.find(params[:id])
    end

    def new
        @milkshake = Milkshake.new
        @ingredients = Ingredient.all
    end

    def create
        whitelisted_params = params.require(:milkshake).permit(:name, :description, :price, :pic, ingredient_ids: [])

        @milkshake = current_user.milkshakes.create(whitelisted_params)
        
        if @milkshake.errors.any?
            @ingredients = Ingredient.all
            render "new"
        else 
            redirect_to milkshake_path(@milkshake)
        end
    end

    def edit
        @milkshake = Milkshake.find(params[:id])
    end
end