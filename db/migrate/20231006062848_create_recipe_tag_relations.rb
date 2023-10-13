class CreateRecipeTagRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :recipe_tag_relations do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true


      t.timestamps
    end
    # 同じタグは２回保存出来ない
    add_index :recipe_tag_relations, [:recipe_id,:tag_id],unique: true
  end
end
