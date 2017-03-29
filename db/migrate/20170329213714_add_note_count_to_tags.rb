class AddNoteCountToTags < ActiveRecord::Migration[5.0]
  def change
    add_column :tags, :note_count, :integer
  end
end
