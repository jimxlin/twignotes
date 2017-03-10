class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.text :name
      t.boolean :mention, default: false
      t.integer :user_id
      t.timestamps
    end
    add_index :tags, :user_id
  end
end
