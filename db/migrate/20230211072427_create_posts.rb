class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :caption
      t.integer :user_id

      t.timestamps
    end
  end
end
