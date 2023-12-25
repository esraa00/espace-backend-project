class RemoveStringColumnFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :string
  end
end
