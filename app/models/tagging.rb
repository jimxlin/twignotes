class Tagging < ApplicationRecord
  belongs_to :note
  belongs_to :tag

  validates_uniqueness_of :note_id, scope: :tag_id
end
