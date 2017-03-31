class Tagging < ApplicationRecord
  belongs_to :note
  belongs_to :tag
  validates_uniqueness_of :note_id, scope: :tag_id

  before_destroy :destroy_orphan_tag
  after_save :update_note_count_for_tag

  private

  def destroy_orphan_tag
    tag.delete if tag.taggings.count == 1
  end

  def update_note_count_for_tag
    tag.update(note_count: tag.notes.unarchived.count)
  end
end
