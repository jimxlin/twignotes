class RemoveUserIdFromTags < ActiveRecord::Migration[5.0]
  def change
    remove_column :tags, :user_id, :integer
  end
end
