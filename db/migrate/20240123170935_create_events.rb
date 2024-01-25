class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title
      t.date :date
      t.string :location
      t.string :category
      t.string :description

      t.timestamps
    end
  end
end
