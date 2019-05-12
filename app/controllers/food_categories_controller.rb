# frozen_string_literal: true

class FoodCategoriesController < ApplicationController
  def index
    @food_categories = current_group.food_categories.order("position")
  end

  def new
    @food_category = FoodCategory.new
  end

  def create
    @food_category = current_group.food_categories.new(food_category_params)
    if @food_category.save
      redirect_to food_categories_url, notice: "#{@food_category.name} を登録しました"
    else
      render "new"
    end
  end

  def edit
    @food_category = current_group.food_categories.find(params[:id])
  end

  def update
    @food_category = current_group.food_categories.find(params[:id])
    if @food_category.update(food_category_params)
      redirect_to food_categories_url, notice: "カテゴリーの名称を #{@food_category.name} に更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @food_category = current_group.food_categories.find(params[:id])
    @food_category.destroy
    redirect_to food_categories_url, notice: "カテゴリー #{@food_category.name} を削除しました"
  end

  private

    def food_category_params
      params.require(:food_category).permit(:name)
    end
end
