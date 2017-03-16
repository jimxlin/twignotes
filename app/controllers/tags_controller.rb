class TagsController < ApplicationController
  def index
    if current_user
      render json: current_user.tags.order(:name)
    else
      render json: nil, status: :ok
    end
  end
end
