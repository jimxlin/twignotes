class NotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def filtered_index
    if current_user
      render json: filtered_notes(params[:tags])
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

  def filtered_notes(tags)
    if tags.nil?
      current_user.notes
    else
      notes = current_user.notes.joins(:taggings)
        .where(taggings: { tag_id: tags })

      # client requests untagged notes
      untagged = 'UntaggedUntaggedUntaggedUntaggedUntaggedUntaggedUntaggedUntagged'
      if tags.include?(untagged)
        notes += current_user.notes.left_outer_joins(:taggings) # notes is now an array, no longer an AR object
          .where(taggings: { id: nil })
      end

      notes
    end
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
