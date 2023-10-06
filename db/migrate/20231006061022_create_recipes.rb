class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.integer :user_id, null: false
      t.integer :original_menu_id, null: false
      t.string :name, null: false
      t.text :description
      t.boolean :is_draft, null: false, default: false

      t.timestamps
    end
  end
end
