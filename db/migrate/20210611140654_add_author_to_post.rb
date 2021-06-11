class AddAuthorToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :author_id, :int
  end
end
