class ChangeCategoryColumnNullableInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column :posts, :category_id, :bigint, null: true
  end
end
