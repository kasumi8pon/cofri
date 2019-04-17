# frozen_string_literal: true

class FoodsController < ApplicationController
  def index
    @foods = Food.all
  end

  def show
    @food = Food.find(params[:id])
  end

  def new
    @food = Food.new
  end

  def create
    food = Food.new(food_params)
    if food.save
      redirect_to foods_url, notice: "#{food.name}を冷蔵庫に登録しました"
    else
      render "new"
    end
  end

  def edit
    @food = Food.find(params[:id])
  end

  def update
    food = Food.find(params[:id])
    if food.update(food_params)
      redirect_to foods_url, notice: "#{food.name}の情報を更新しました"
    else
      edit
    end
  end

  def destroy
    food = Food.find(params[:id])
    food.destroy
    redirect_to foods_url, notice: "#{food.name}を冷蔵庫から削除しました"
  end

  private

    def food_params
      params.require(:food).permit(:name, :amount)
    end
end
