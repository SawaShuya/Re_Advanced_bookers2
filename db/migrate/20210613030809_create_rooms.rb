class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.integer :admin_id
      t.boolean :is_direct_message, null: false, default: false
      t.timestamps
    end
  end
end
