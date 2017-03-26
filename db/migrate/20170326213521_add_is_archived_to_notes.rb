class AddIsArchivedToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :is_archived, :boolean, default: false
  end
end
