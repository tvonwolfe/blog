class CreateLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :links do |t|
      t.string :target_url, null: false
      t.string :target_domain

      t.timestamps

      t.index %i[target_url], unique: true
      t.index %i[target_domain]
    end
  end
end
