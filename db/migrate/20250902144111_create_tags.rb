class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :value

      # tags don't change
      t.datetime :created_at, null: false

      t.index :value, unique: true
    end
  end
end
