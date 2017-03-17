class TagsController < ApplicationController
  def index
    if current_user
      # get count, append that value to each element in array below
      render json: current_user.tags.order(:name).uniq,
    else
      render json: nil, status: :ok
    end
  end
end
