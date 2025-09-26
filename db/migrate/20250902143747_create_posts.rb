class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :handle, null: false
      t.text :content, null: false
      t.datetime :published_at

      t.timestamps

      t.index :handle, unique: true
    end
  end
end
