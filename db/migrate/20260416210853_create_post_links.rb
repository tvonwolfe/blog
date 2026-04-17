class CreatePostLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :post_links do |t|
      t.references :post, null: false, foreign_key: true
      t.references :link, null: false, foreign_key: true

      t.timestamps
    end
  end
end
