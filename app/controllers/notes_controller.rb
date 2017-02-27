class NotesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]

  def index
    if current_user
      render json: current_user.notes.order(:updated_at)
    else
      render json: nil, status: :ok
    end
  end

  def new
    @note = Note.new
  end

  def create
    note = current_user.notes.create(note_params)
    render json: note
  end

  def update
    note = Note.find(params[:id])
    note.update_attributes(note_params)
    render json: note
  end

  def destroy
    Task.find(params[:id]).destroy
    render json: nil, status: :ok
  end

  private

  def note_params
    params.require(:gram).permit(:title, :body)
  end

  def get_tags
    hashtags = []
    mentions = []
  end
end
