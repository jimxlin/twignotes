class Tagging < ApplicationRecord
  belongs_to :note
  belongs_to :tag
  validates_uniqueness_of :note_id, scope: :tag_id

  after_save :update_note_count_for_tag

  private

  def update_note_count_for_tag
    tag.update(note_count: tag.notes.count)
  end
end
