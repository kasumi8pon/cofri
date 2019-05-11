# frozen_string_literal: true

class Api::FoodsController < ApplicationController
  def index
    @foods = current_group.foods
    render "index", formats: "json", handlers: "jbuilder"
  end

  def update
    food = current_group.foods.find(params[:id])
    if food.update(amount: params[:amount])
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
