class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: filtered_notes(params[:tags], params[:archive], params[:jointype])
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

  UNTAGGED = 'UntaggedUntaggedUntaggedUntaggedUntaggedUntaggedUntaggedUntagged' # remove the need for this

  def filtered_notes(tags, archive, jointype)
    if tags.nil?
      archive == 'true' ? current_user.notes.archived : current_user.notes.unarchived
    else
      tag_ids = tags.map {|t| t.to_i}
      if jointype == 'OR'
        notes = current_user.notes.unarchived.
          joins(:taggings).where(taggings: { tag_id: tag_ids })
      elsif jointype == 'AND'
        notes =
          current_user.notes.includes(:tags).select do |note|
            ( tag_ids - note.tags.map {|t| t.id} ).empty?
          end
      end
      if tags.include?(UNTAGGED) # client requests untagged notes
        untagged_notes = current_user.notes.unarchived.left_outer_joins(:taggings)
          .where(taggings: { id: nil })
        notes += untagged_notes
      end
      notes.to_a.uniq
    end
  end

  def note_params
    params.require(:note).permit(:title, :body, :is_archived)
  end
end
