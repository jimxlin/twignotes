class Tagging < ApplicationRecord
  belongs_to :note
  belongs_to :tag
  validates_uniqueness_of :note_id, scope: :tag_id

  before_destroy :update_note_count_for_tag_on_destroy
  before_destroy :destroy_orphan_tag
  after_save :update_note_count_for_tag

  private

  def update_note_count_for_tag_on_destroy
    tag.update(note_count: tag.note_count - 1)
  end

  def destroy_orphan_tag
    tag.delete if tag.taggings.count == 1
  end

  def update_note_count_for_tag
    tag.update(note_count: tag.notes.count)
  end
end
