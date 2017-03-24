class TagsController < ApplicationController
  def index
    if current_user
      # create array of hashes with object properties
      render json: current_user.tags.order(:name).distinct
    else
      render json: nil, status: :ok
    end
  end
end
