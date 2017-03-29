class AddUserIdIndexToTags < ActiveRecord::Migration[5.0]
  def change
    add_index :tags, :user_id
  end
end
