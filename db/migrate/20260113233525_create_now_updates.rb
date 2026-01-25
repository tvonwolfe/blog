class CreateNowUpdates < ActiveRecord::Migration[8.1]
  def change
    create_table :now_updates do |t|
      t.text :content, null: false

      t.timestamps
    end
  end
end
