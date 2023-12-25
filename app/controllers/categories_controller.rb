class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    return render json: @categories ,status: :ok
  end
end