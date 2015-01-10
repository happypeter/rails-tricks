class ChangeThingsInComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer
    remove_column :comments, :username
    remove_column :comments, :email
  end
end
