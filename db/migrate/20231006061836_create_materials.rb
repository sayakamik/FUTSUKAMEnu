class CreateMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :materials do |t|
      t.integer :recipe_id, null: false
      t.string :content, null: false
      t.string :quantity, null: false

      t.timestamps
    end
  end
end
