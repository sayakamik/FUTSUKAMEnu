class Recipe < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  # accepts_nested_attributes_forで子カラムを一緒に保存できるようになる。
  # reject_if: :all_blankは、不要な空レコードの生成を防ぐ
  # allow_destroy: trueは、関連する子レコードを簡単に削除
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true
  has_many :procedures, dependent: :destroy
  accepts_nested_attributes_for :procedures, reject_if: :all_blank, allow_destroy: true

  has_many :recipe_tag_relations, dependent: :destroy
  has_many :tags, dependent: :destroy

  belongs_to :original_menu
  attribute :original_menu_name

  before_validation :original_menu_create_check

  has_one_attached :menu_image

  #バリデーションテスト前につけた場合rails db:migrate resetでデータ削除もしくはrails cでけしてもOK。
  #context: :publicizeでレシピが公開された時のバリデーション（下書き段階ではなくてもOKのため）
  with_options presence: true, on: :publicize do
    #with_optionsは複数のバリデーションをグループ化し共通の制限をかけるときに使用。
    validates :menu_image
    validates :name
    validates :description
    #validates :original_menuったん。まだ入れてないため
  end
  validates :name, length: { maximum: 50 }, on: :publicize
  validates :description, length: { maximum: 100 }, on: :publicize

  def get_menu_image(width, height)
    unless menu_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      menu_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpg')
    end
    menu_image.variant(resize_to_limit: [width, height]).processed
  end

  #レシピ公開・下書き時のステータス処理
  def is_draft_text
    if self.is_draft == false
      '公開'
    else
      '下書き'
    end
  end

  private

  #レシピ投稿時のscriptではチェックできない部分を、バリデーション前に確認するため。
  def original_menu_create_check
    if original_menu_id.blank? && original_menu_name.present?
      original_menu = OriginalMenu.find_or_create_by(name: original_menu_name)
      self.original_menu_id = original_menu.id
    end
  end

end
