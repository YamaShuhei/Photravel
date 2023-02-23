# frozen_string_literal: true

class CreatePostTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tags do |t|
      t.references :post, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
    # 同タグは１つまで
    add_index :post_tags, [:post_id, :tag_id], unique: true
  end
end
