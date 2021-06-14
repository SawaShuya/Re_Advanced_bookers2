class AddPageViewsToBook < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :page_views, :integer, default: 0
  end
end
