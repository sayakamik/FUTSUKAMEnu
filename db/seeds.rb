# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.find_or_create_by!(email: 'futsuka@menu') do |admin|
  admin.password= 'futsukameadmin'
end

user_data = [
  { email: "yae@example.com", name: "Yae", password: "yaechan", image: "sample-user1.jpg" },
  { email: "aki@example.com", name: "Aki", password: "akichan", image: "sample-user2.jpg" },
  { email: "natsu@example.com", name: "Natsu", password: "natsuchan", image: "sample-user3.jpg" },
  { email: "fuyu@example.com", name: "Fuyu", password: "fuyuchan"},
  { email: "take@example.com", name: "Take", password: "takechan"}
]

user_data.each do |data|
  User.find_or_create_by!(email: data[:email]) do |user|
    user.name = data[:name]
    user.password = data[:password]
    user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/#{data[:image]}"), filename: data[:image])
  end
end

#1日目メニューoriginal_menu
original_menu_names = ["肉じゃが", "豚キムチ", "ポテトサラダ", "ポトフ", "肉野菜炒め"]

original_menu_names.each do |menu_name|
  OriginalMenu.find_or_create_by!(name: menu_name) do |original_menu|
  end
end

#タグtag
tag_names = ["簡単", "ご飯もの", "野菜", "おかず", "サラダ", "揚げ物", "麺類"]

tag_names.each do |tag_name|
  Tag.find_or_create_by!(tag_name: tag_name)
end

#カレー
Recipe.find_or_create_by!(name: "カレー") do |recipe|
  recipe.menu_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/カレー.jpg"), filename:"カレー.jpg")
  recipe.name = "カレー"
  recipe.description = "肉じゃがからのアレンジレシピです！"
  recipe.user_id = 1
  recipe.original_menu_id = 1
end

[1, 2].each do |tag_id|
  RecipeTagRelation.find_or_create_by!(recipe_id: 1, tag_id: tag_id)
end

ingredients_data = [
  { content: "余った肉じゃが", recipe_id: 1, quantity: "必要な分" },
  { content: "水", recipe_id: 1, quantity: "適量" },
  { content: "カレールー", recipe_id: 1, quantity: "適量" }
]
procedures_data = [
  { direction: "余った肉じゃがと水を鍋に入れ、中火で温める", recipe_id: 1},
  { direction: "温まったら火を止め、カレールーを入れて溶かす", recipe_id: 1 },
  { direction: "濃さは水とカレールーで調整し、とろみがつくまで弱火で５分ほど煮込んだら完成！", recipe_id: 1}
]

ingredients_data.each do |data|
  ingredient = Ingredient.find_by(data.slice(:recipe_id, :content))
  Ingredient.create!(data) unless ingredient
end

procedures_data.each do |data|
  procedure = Procedure.find_by(data.slice(:recipe_id, :direction))
  Procedure.create!(data) unless procedure
end

#キムチチャーハン
Recipe.find_or_create_by!(name: "キムチチャーハン") do |recipe|
  recipe.menu_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/キムチチャーハン.jpg"), filename:"キムチチャーハン.jpg")
  recipe.name = "キムチチャーハン"
  recipe.description = "豚キムチからのアレンジレシピです！"
  recipe.user_id = 1
  recipe.original_menu_id = 2
end

[1, 2].each do |tag_id|
  RecipeTagRelation.find_or_create_by!(recipe_id: 2, tag_id: tag_id)
end

ingredients_data = [
  { content: "余った豚キムチ", recipe_id: 2, quantity: "余った分" },
  { content: "ご飯（できれば冷ご飯）", recipe_id: 2, quantity: "適量" },
  { content: "ごま油", recipe_id: 2, quantity: "適量" },
  { content: "卵", recipe_id: 2, quantity: "1個/1人" },
  { content: "青ネギ", recipe_id: 2, quantity: "適量" }
]
procedures_data = [
  { direction: "余った豚キムチを料理バサミで細かくする（包丁でも問題なし）", recipe_id: 2},
  { direction: "フライパンにごま油を入れ、水分が入らないように豚キムチを入れ、炒める。＊水分が入っても炒めて水分を切れば問題ないです。", recipe_id: 2 },
  { direction: "フライパンに冷やご飯を追加し、キムチとご飯を均等に混ぜて炒める。", recipe_id: 2},
  { direction: "目玉焼きを作り、キムチ炒飯の上に目玉焼きと青ネギを刻んでのせれば完成！", recipe_id: 2}
]

ingredients_data.each do |data|
  ingredient = Ingredient.find_by(data.slice(:recipe_id, :content))
  Ingredient.create!(data) unless ingredient
end

procedures_data.each do |data|
  procedure = Procedure.find_by(data.slice(:recipe_id, :direction))
  Procedure.create!(data) unless procedure
end

#コロッケ
Recipe.find_or_create_by!(name: "コロッケ") do |recipe|
  recipe.menu_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/コロッケ.jpg"), filename:"コロッケ.jpg")
  recipe.name = "コロッケ"
  recipe.description = "ポテトサラダのアレンジレシピ＊傷みやすくなるためきゅうりは使用していません"
  recipe.user_id = 2
  recipe.original_menu_id = 3
end

[1, 3, 4, 6].each do |tag_id|
  RecipeTagRelation.find_or_create_by!(recipe_id: 3, tag_id: tag_id)
end

ingredients_data = [
  { content: "余ったポテトサラダ", recipe_id: 3, quantity: "余った分" },
  { content: "とろけるチーズ", recipe_id: 3, quantity: "好きな分" },
  { content: "小麦粉", recipe_id: 3, quantity: "適量" },
  { content: "卵", recipe_id: 3, quantity: "1〜2個" },
  { content: "パン粉", recipe_id: 3, quantity: "適量" },
  { content: "揚げ油", recipe_id: 3, quantity: "適量" }
]
procedures_data = [
  { direction: "余ったポテトサラダを手に広げ、中にチーズを入れ、コロッケのサイズに丸める。＊水分が多い場合は小さめがおすすめ", recipe_id: 3},
  { direction: "丸めたポテトサラダに小麦粉、溶き卵、パン粉を順番にまぶし、形を整えて容器に置く。", recipe_id: 3 },
  { direction: "揚げ油を熱し、丸めたコロッケを入れきつね色になったら油を切って完成です。", recipe_id: 3}
]

ingredients_data.each do |data|
  ingredient = Ingredient.find_by(data.slice(:recipe_id, :content))
  Ingredient.create!(data) unless ingredient
end

procedures_data.each do |data|
  procedure = Procedure.find_by(data.slice(:recipe_id, :direction))
  Procedure.create!(data) unless procedure
end

#シチュー
Recipe.find_or_create_by!(name: "クリームシチュー") do |recipe|
  recipe.menu_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/シチュー.jpg"), filename:"シチュー.jpg")
  recipe.name = "クリームシチュー"
  recipe.description = "ポトフの2日目レシピです"
  recipe.user_id = 2
  recipe.original_menu_id = 4
end

[1, 3, 4].each do |tag_id|
  RecipeTagRelation.find_or_create_by!(recipe_id: 4, tag_id: tag_id)
end

ingredients_data = [
  { content: "余ったポトフ", recipe_id: 4, quantity: "余った分" },
  { content: "クリームシチューのルー", recipe_id: 4, quantity: "必要な分" },
  { content: "水または牛乳", recipe_id: 4, quantity: "必要な場合適量" }
]
procedures_data = [
  { direction: "余ったポトフを鍋に入れ温める。", recipe_id: 4},
  { direction: "沸騰したら火を止め、クリームシチューのルーを入れて溶かす。", recipe_id: 4 },
  { direction: "必要な場合水または牛乳とルーで濃さを調節して完成！", recipe_id: 4}
]

ingredients_data.each do |data|
  ingredient = Ingredient.find_by(data.slice(:recipe_id, :content))
  Ingredient.create!(data) unless ingredient
end

procedures_data.each do |data|
  procedure = Procedure.find_by(data.slice(:recipe_id, :direction))
  Procedure.create!(data) unless procedure
end

#焼きそば
Recipe.find_or_create_by!(name: "焼きそば") do |recipe|
  recipe.menu_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/シチュー.jpg"), filename:"シチュー.jpg")
  recipe.name = "焼きそば"
  recipe.description = "野菜炒めのアレンジレシピです"
  recipe.user_id = 3
  recipe.original_menu_id = 5
end

[1, 3, 7].each do |tag_id|
  RecipeTagRelation.find_or_create_by!(recipe_id: 5, tag_id: tag_id)
end

ingredients_data = [
  { content: "余った肉野菜炒め", recipe_id: 5, quantity: "必要な分" },
  { content: "焼きそば用の中華麺", recipe_id: 5, quantity: "必要な分" },
  { content: "塩胡椒", recipe_id: 5, quantity: "適量" },
  { content: "焼きそば用のソース", recipe_id: 5, quantity: "適量" }
]
procedures_data = [
  { direction: "肉野菜炒めをフライパンで火を通す。", recipe_id: 5},
  { direction: "肉野菜炒めが入ったフライパンの中に中華麺を入れて麺をほぐし、塩胡椒で下味をつけて炒める。", recipe_id: 5},
  { direction: "ソースを入れて全体に絡ますように炒め、味を整えたら完成です。", recipe_id: 5}
]

ingredients_data.each do |data|
  ingredient = Ingredient.find_by(data.slice(:recipe_id, :content))
  Ingredient.create!(data) unless ingredient
end

procedures_data.each do |data|
  procedure = Procedure.find_by(data.slice(:recipe_id, :direction))
  Procedure.create!(data) unless procedure
end