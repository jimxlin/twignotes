class TaggingsController < ApplicationController
  def index
    if current_user
      render json: current_user.taggings
    else
      render json: nil, status: :ok
    end
  end
end
