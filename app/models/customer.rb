class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items,  dependent: :destroy
  has_many :addresses,   dependent: :destroy
  has_many :orders,      dependent: :destroy

  # 名前（必須）
  validates :last_name,  presence: true
  validates :first_name, presence: true
  # フリガナ（必須・全角カタカナ）
  validates :last_name_kana,  presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  # 郵便番号（7桁の半角数字）
  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/, message: "はハイフンなし7桁で入力してください" }
  # 住所（必須）
  validates :address, presence: true
  # 電話番号（10〜11桁の半角数字）
  validates :telephone_number, presence: true, format: { with: /\A\d{10,11}\z/, message: "はハイフンなしで入力してください" }

  enum is_active: { active: 0, inactive: 1 }
end
