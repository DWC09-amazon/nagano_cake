# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'
Faker::Config.locale = :ja

# 初期化
puts "=====データを削除中...====="
Admin.destroy_all
Customer.destroy_all
Address.destroy_all
Genre.destroy_all
Item.destroy_all
CartItem.destroy_all
Order.destroy_all
OrderDetail.destroy_all
puts "=====削除完了====="

sleep(0.5)

# テストデータ作成

# 管理者
Admin.create!(email: "admin@example.com", password: "password")
puts "=====管理者を作成しました====="

# 一般会員
customers = []

clean_phone_number_fixed = Faker::PhoneNumber.cell_phone.delete("()-. ")

customers << Customer.create!(
    last_name: "令和",
    first_name: "道子",
    last_name_kana: "レイワ",
    first_name_kana: "ミチコ",
    email: "example@example.com",
    password: "password",
    postal_code: Faker::Number.number(digits: 7),
    address: Faker::Address.full_address,
    telephone_number: clean_phone_number_fixed,
    is_active: true
)

14.times do
  last_name_kanji = Faker::Name.last_name
  first_name_kanji = Faker::Name.first_name

  last_name_kana_dummy = "セイ"
  first_name_kana_dummy = "メイ"

  clean_phone_number = Faker::PhoneNumber.cell_phone.delete("()-. ")

  customers << Customer.create!(
    last_name: last_name_kanji,
    first_name: first_name_kanji,
    last_name_kana: last_name_kana_dummy,
    first_name_kana: first_name_kana_dummy,
    email: Faker::Internet.unique.email,
    password: "password",
    postal_code: Faker::Number.number(digits: 7),
    address: Faker::Address.full_address,
    telephone_number: clean_phone_number,
    is_active: true
  )
end
puts "=====会員15件を作成しました====="

# 配送先
customers.each do |customer|
  2.times do
    Address.create!(
      customer: customer,
      name: "#{customer.last_name} #{customer.first_name}",
      postal_code: Faker::Number.number(digits: 7),
      address: Faker::Address.full_address
    )
  end
end
puts "=====配送先を30件作成しました====="

# ジャンル
puts "=====ジャンルを登録中...====="

genre_names = [
  "ケーキ",
  "焼き菓子",
  "タルト・パイ",
  "チョコレート菓子",
  "キャンディ・飴",
  "砂糖菓子",
  "ギフト・その他"
]

genres = genre_names.map do |name|
  Genre.create!(name: name)
end

puts "=====ジャンルを7件作成しました====="

# 商品
puts "=====商品データを登録中...====="

item_data = [
  { name: "苺のショートケーキ", introduction: "ふわふわスポンジと甘酸っぱい苺のハーモニー", image: "cake01.png", genre: "ケーキ" },
  { name: "チョコレートケーキ", introduction: "濃厚なチョコの香りと口どけが魅力", image: "chocolate_cake.png", genre: "ケーキ" },
  { name: "チーズケーキ", introduction: "ベイクドタイプの濃厚チーズケーキ", image: "cheesecake.png", genre: "ケーキ" },
  { name: "モンブラン", introduction: "栗の風味が香る上品な味わい", image: "montblanc.png", genre: "ケーキ" },
  { name: "フィナンシェ", introduction: "焦がしバター香るしっとり焼き菓子", image: "financier.png", genre: "焼き菓子" },
  { name: "マドレーヌ", introduction: "レモンが香る定番の焼き菓子", image: "madeleine.png", genre: "焼き菓子" },
  { name: "クッキー詰め合わせ", introduction: "バター香る手作りクッキーのセット", image: "yakigashi01.png", genre: "ギフト・その他" },
  { name: "プリン", introduction: "とろけるなめらか食感のカスタードプリン", image: "pudding01.png", genre: "ケーキ" },
  { name: "カスタードタルト", introduction: "サクサク生地にたっぷりカスタード", image: "custard_tart.png", genre: "タルト・パイ" },
  { name: "アップルパイ", introduction: "リンゴの甘酸っぱさが広がる伝統の味", image: "apple_pie.png", genre: "タルト・パイ" },
  { name: "キャンディセット", introduction: "カラフルで可愛いキャンディ詰め合わせ", image: "candies.png", genre: "キャンディ・飴" },
  { name: "マカロン", introduction: "フランス風の繊細な焼き菓子", image: "macaron.png", genre: "砂糖菓子" },
  { name: "シュークリーム", introduction: "カスタードがたっぷり入った人気商品", image: "cream_puff.png", genre: "ケーキ" },
  { name: "ガトーショコラ", introduction: "しっとり濃厚なガトーショコラ", image: "gateau_chocolat.png", genre: "チョコレート菓子" },
  { name: "キャンディ", introduction: "カラフルでどれも美味しいキャンディ", image: "candy01.png", genre: "キャンディ・飴" }
]

items = []

item_data.each do |data|
  genre = genres.find { |g| g.name == data[:genre] } || genres.sample
  item = Item.create!(
    name: data[:name],
    introduction: data[:introduction],
    genre: genre,
    price: rand(300..800),
    is_active: 0
  )

  # 画像ファイルをattach（app/assets/images/items/ 以下に保存）
  image_path = Rails.root.join("app/assets/images/items/#{data[:image]}")
  if File.exist?(image_path)
    item.item_image.attach(io: File.open(image_path), filename: data[:image])
  else
    puts "=====⚠️ 画像ファイルが見つかりません=====: #{data[:image]}"
  end

  items << item
end

puts "=====商品15件を作成しました（画像付き）====="

# カートアイテム
customers.each do |customer|
  3.times do
    CartItem.create!(
      customer: customer,
      item: items.sample,
      amount: rand(1..5)
    )
    sleep(0.05)
  end
end
puts "=====カートアイテムを作成しました====="

# 注文
orders = []
15.times do
  customer = customers.sample
  orders << Order.create!(
    customer: customer,
    postal_code: Faker::Number.number(digits: 7),
    address: Faker::Address.full_address,
    name: "#{customer.last_name} #{customer.first_name}",
    shipping_cost: 800,
    total_payment: rand(1000..5000),
    payment_method: rand(0..1),
    status: rand(0..4)
  )
end
puts "=====注文15件を作成しました====="

# 注文詳細
orders.each do |order|
  rand(1..5).times do
    item = items.sample
    OrderDetail.create!(
      order: order,
      item: item,
      price: item.price,
      amount: rand(1..3),
      making_status: rand(0..3)
    )
    sleep(0.05)
  end
end
puts "=====注文明細を作成しました====="

puts "=====テストデータの作成が完了しました！====="