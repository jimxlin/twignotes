class NotesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: filtered_notes(params)
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

  def filtered_notes(params)
    tags =     params[:tags]
    archive =  params[:archive]
    jointype = params[:jointype]
    untagged = params[:untagged]

    return get_all_notes(archive, untagged) if tags.nil?

    tag_ids = tags.map {|t| t.to_i}
    case jointype
    when 'OR'
      notes = get_or_tags_notes(tag_ids)
    when 'AND'
      notes = get_and_tags_notes(tag_ids)
    else
      raise Exception.new("Invalid join type was provided.")
    end

    notes += get_untagged_notes if untagged == 'true'
    notes.to_a.uniq
  end

  def get_all_notes(archive, untagged)
    if archive == 'true'
      current_user.notes.archived
    elsif untagged == 'true'
      current_user.notes.unarchived.
        left_outer_joins(:taggings).where(taggings: { id: nil })
    else
      current_user.notes.unarchived
    end
  end

  def get_or_tags_notes(tag_ids)
    current_user.notes.unarchived.
      joins(:taggings).where(taggings: { tag_id: tag_ids })
  end

  def get_and_tags_notes(tag_ids)
    current_user.notes.includes(:tags).select do |note|
      ( tag_ids - note.tags.map {|t| t.id} ).empty?
    end
  end

  def get_untagged_notes
    current_user.notes.unarchived.
      left_outer_joins(:taggings).where(taggings: { id: nil })
  end

  def note_params
    params.require(:note).permit(:title, :body, :is_archived)
  end
end
