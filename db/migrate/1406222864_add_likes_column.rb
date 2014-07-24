class AddLikesColumn < ActiveRecord::Migration
  def change
    add_column :messages, :likes, :integer, :default => 0
  end

  def down
    # add reverse migration code here
  end
end
