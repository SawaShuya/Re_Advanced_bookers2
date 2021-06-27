class AddRateToBook < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :evaluation, :float, null: false, default: 0
  end
end
