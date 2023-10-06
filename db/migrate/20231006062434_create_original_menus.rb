class CreateOriginalMenus < ActiveRecord::Migration[6.1]
  def change
    create_table :original_menus do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
