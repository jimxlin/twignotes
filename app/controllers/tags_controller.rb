class TagsController < ApplicationController
  def index
    if current_user
      render json: tags_with_note_count
    else
      render json: nil, status: :ok
    end
  end

  private

  def tags_with_note_count
    notes = (params[:archived] == 'false') ? current_user.notes.unarchived : current_user.notes.archived
    current_user.tags.order(:name).distinct.map do |tag|
      note_count = notes.joins(:taggings)
        .where(taggings: { tag_id: tag.id }).count

      { id: tag.id, name: tag.name, mention: tag.mention, count: note_count }
    end
  end
end
