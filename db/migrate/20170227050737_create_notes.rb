class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.text :title
      t.text :body
      t.integer :user_id
      t.timestamps
    end
    add_index :notes, :user_id
  end
end
