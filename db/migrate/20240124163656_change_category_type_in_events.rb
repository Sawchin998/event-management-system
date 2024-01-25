class ChangeCategoryTypeInEvents < ActiveRecord::Migration[7.0]
  def change
    change_column :events, :category, :integer
  end
end
