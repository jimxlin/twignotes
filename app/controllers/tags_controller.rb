class TagsController < ApplicationController
  def index
    if current_user
      # need to add a 'virtual' count attribute to each tag
      render json: current_user.tags.order(:name).distinct
    else
      render json: nil, status: :ok
    end
  end
end
