# frozen_string_literal: true

class FoodCategoriesController < ApplicationController
  def index
    @food_categories = current_group.food_categories.order("position")
  end

  def new
    @food_category = FoodCategory.new
    @back_path = back_path
  end

  def create
    @food_category = current_group.food_categories.new(food_category_params)
    if @food_category.save
      if params[:food_category][:from] == "food_new"
        redirect_to new_food_url, notice: "カテゴリー #{@food_category.name} を登録しました"
      elsif params[:food_category][:from] == "food_edit"
        redirect_to edit_food_url(params[:food_category][:edit_id]), notice: "カテゴリー #{@food_category.name} を登録しました"
      else
        redirect_to food_categories_url, notice: "#{@food_category.name} を登録しました"
      end
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
    if @food_category.destroy
      redirect_to food_categories_url, notice: "カテゴリー #{@food_category.name} を削除しました"
    else
      redirect_to food_categories_url, notice: "カテゴリー #{@food_category.name} には食材があるため、削除できませんでした"
    end
  end

  private

    def food_category_params
      params.require(:food_category).permit(:name)
    end

    def back_path
      if params[:from] == "food_new"
        new_food_url
      elsif params[:from] == "food_edit"
        edit_food_url(params[:edit_id])
      else
        food_categories_url
      end
    end
end
