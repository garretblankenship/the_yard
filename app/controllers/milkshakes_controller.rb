class MilkshakesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_milkshake, only: [:show]
    before_action :set_user_milkshake, only: [:edit, :update]
    
    def index
        if params[:search] && !params[:search].empty?
            @milkshakes = Milkshake.where(name: params[:search])
        else
            @milkshakes = Milkshake.all
        end
    end

    def show
        session = Stripe::Checkout::Session.create(
            payment_method_types: ["card"],
            customer_email: current_user.email,
            line_items: [
                {
                    name: @milkshake.name,
                    description: @milkshake.description,
                    amount: @milkshake.price,
                    currency: "aud",
                    quantity: 1
                }
            ],
            payment_intent_data: {
                metadata: {
                    user_id: current_user.id,
                    milkshake_id: @milkshake.id
                }
            },
            success_url: "#{root_url}payment/success?userId=#{current_user.id}&milkshakeId=#{@milkshake.id}",
            cancel_url: "#{root_url}milkshakes/#{@milkshake.id}"
        )

        @session_id = session.id
        @public_key = Rails.application.credentials.dig(:stripe, :public_key)
    end

    def new
        @milkshake = Milkshake.new
        @ingredients = Ingredient.all
    end

    def create
        @milkshake = current_user.milkshakes.create(milkshake_params)
        
        if @milkshake.errors.any?
            @ingredients = Ingredient.all
            render "new"
        else 
            redirect_to milkshake_path(@milkshake)
        end
    end

    def edit
        @ingredients = Ingredient.all
    end

    def update        
        if @milkshake.update(milkshake_params)
            redirect_to milkshake_path(params[:id])
        else
            @ingredients = Ingredient.all
            render "edit"
        end
    end

    private
    def milkshake_params
        params.require(:milkshake).permit(:name, :description, :price, :pic, ingredient_ids: [])
    end

    def set_milkshake
        @milkshake = Milkshake.find(params[:id])
    end

    def set_user_milkshake
        @milkshake = current_user.milkshakes.find_by_id(params[:id])

        if @milkshake == nil
            redirect_to milkshakes_path
        end
    end
end