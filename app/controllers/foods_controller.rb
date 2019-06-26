# frozen_string_literal: true

class FoodsController < ApplicationController
  skip_before_action :login_required, only: :index

  def index
    if current_user
      @foods = current_group.foods
    else
      render template: "home/index"
    end
  end

  def show
    @food = current_group.foods.find(params[:id])
  end

  def new
    @current_group = current_group
    @food = Food.new
  end

  def create
    @food = current_group.foods.new(food_params)
    if @food.save
      redirect_to foods_url, notice: "#{@food.name}を冷蔵庫に登録しました"
    else
      render "new"
    end
  end

  def edit
    @current_group = current_group
    @food = current_group.foods.find(params[:id])
  end

  def update
    @food = current_group.foods.find(params[:id])
    if @food.update(food_params)
      redirect_to foods_url, notice: "#{@food.name}の情報を更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @food = current_group.foods.find(params[:id])
    @food.destroy
    redirect_to foods_url, notice: "#{@food.name}を冷蔵庫から削除しました"
  end

  private

    def food_params
      params.require(:food).permit(:name, :amount, :food_category_id, :to_buy)
    end
end
