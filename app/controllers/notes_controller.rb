class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    notes = current_user.notes
    render json: notes_with_tags(notes)
  end

  def create
    @note = current_user.notes.create(note_params)
  end

  def update
    # Don't update timestamps for archiving / unarchiving
    archive_change = params[:note][:is_archived] ? true : false

    Note.record_timestamps = false if archive_change
    note = Note.find(params[:id])
    note.update(note_params)
    Note.record_timestamps = true if archive_change

    render json: note
  end

  def destroy
    current_user.notes.find(params[:id]).destroy
    render json: nil, status: :ok
  end

  def empty_archives
    current_user.notes.archived.destroy_all
    render json: nil, status: :ok
  end

  private

  def notes_with_tags(notes)
    notes.includes(:tags).map do |note|
      tags = note.tags.map { |tag| tag.id }
      { id: note.id, title: note.title, body: note.body, user_id: note.user_id,
        created_at: note.created_at, updated_at: note.updated_at,
        is_archived: note.is_archived, tags: tags }
    end
  end

  def note_params
    params.require(:note).permit(:title, :body, :is_archived)
  end
end
