class AddColumsToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :name, :string
    add_column :rooms, :image_id, :string
    add_column :rooms, :introduction, :text
  end
end
