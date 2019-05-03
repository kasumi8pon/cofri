# frozen_string_literal: true

class Api::FoodsController < ApplicationController
  def update
    food = current_group.foods.find(params[:id])
    if food.update(amount: params[:amount])
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
