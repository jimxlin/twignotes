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
    current_user.tags.order(:name).distinct.map do |tag|
      note_count = current_user.notes.unarchived.joins(:taggings)
        .where(taggings: { tag_id: tag.id }).count

      { id: tag.id, name: tag.name, mention: tag.mention, count: note_count }
    end
  end
end
