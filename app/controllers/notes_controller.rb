class NotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    # note creation modal
    @note = Note.new

    if current_user
      render json: current_user.notes.order(:updated_at)
    else
      render json: nil, status: :ok
    end
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
    Note.find(params[:id]).destroy
    # if item successfully deleted (5xx)
    # or if id never existed (4xx)
    render json: nil, status: :ok
  end

  private

  def note_params
    params.require(:note).permit(:title, :body)
  end

  def get_tags
    hashtags = []
    mentions = []
  end
end
