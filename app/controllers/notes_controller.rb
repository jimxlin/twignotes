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

  ARCHIVED = 'ArchivedArchivedArchivedArchivedArchivedArchivedArchivedArchived'
  UNTAGGED = 'UntaggedUntaggedUntaggedUntaggedUntaggedUntaggedUntaggedUntagged'

  def filtered_notes(tags)

    if tags.nil?
      current_user.notes.unarchived
    elsif tags == [ARCHIVED]
      current_user.notes.archived
    else
      notes = current_user.notes
      # is client in archive mode?
      notes = tags.include?(ARCHIVED) ? notes.archived : notes.unarchived
      notes = notes.joins(:taggings)
        .where(taggings: { tag_id: tags })

      # client requests untagged notes
      if tags.include?(UNTAGGED)
        untagged_notes = current_user.notes.left_outer_joins(:taggings)
          .where(taggings: { id: nil })
        untagged_notes = tags.include?(ARCHIVED) ? untagged_notes.archived : untagged_notes.unarchived
        notes += untagged_notes
      end

      notes.to_a.uniq
    end
  end

  def note_params
    params.require(:note).permit(:title, :body, :is_archived)
  end
end
