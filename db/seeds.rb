# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'faker'
Faker::Config.locale = :ja

# 初期化
puts "=====データを削除中...====="
[Admin, Customer, Address, Genre, Item, CartItem, Order, OrderDetail].each(&:destroy_all)
puts "=====削除完了====="

# 管理者作成
Admin.create!(email: "admin@example.com", password: "password")
puts "=====管理者を作成しました====="

# 一般会員作成
customers = []
customers << Customer.create!(
  last_name: "令和",
  first_name: "道子",
  last_name_kana: "レイワ",
  first_name_kana: "ミチコ",
  email: "example@example.com",
  password: "password",
  postal_code: "0000000",
  address: "東京都渋谷区代々木神園町0-0",
  telephone_number: "0800000000",
  is_active: true
)
10.times do
  customers << Customer.create!(
    last_name: Faker::Name.last_name,
    first_name: Faker::Name.first_name,
    last_name_kana: "セイ",
    first_name_kana: "メイ",
    email: Faker::Internet.unique.email,
    password: "password",
    postal_code:  "0000000",
    address: "東京都港区六本木3-2-1",
    telephone_number: "0900000000",
    is_active: true
  )
end
puts "=====会員11件を作成しました====="

# 配送先作成
customers.each do |customer|
  2.times do
    Address.create!(
      customer: customer,
      name: "#{customer.last_name} #{customer.first_name}",
      postal_code: "0000000",
      address: Faker::Address.full_address
    )
  end
end
puts "=====配送先を作成しました====="

# ジャンル作成
genre_names = ["ケーキ","焼き菓子","タルト・パイ","チョコレート菓子","キャンディ・飴","砂糖菓子","ギフト・その他"]
genres = genre_names.map { |name| Genre.create!(name: name) }
puts "=====ジャンルを7件作成しました====="

# 商品作成
items = []
item_data = [
  { name: "苺のショートケーキ", introduction: "ふわふわスポンジと甘酸っぱい苺のハーモニー", image: "cake01.png", genre: "ケーキ", price: 400 },
  { name: "チョコレートケーキ", introduction: "濃厚なチョコの香りと口どけが魅力", image: "chocolate_cake.png", genre: "ケーキ", price: 400 },
  { name: "フィナンシェ", introduction: "焦がしバター香るしっとり焼き菓子", image: "financier.png", genre: "焼き菓子", price: 300 },
  { name: "マドレーヌ", introduction: "レモンが香る定番の焼き菓子", image: "madeleine.png", genre: "焼き菓子", price: 300 },
  { name: "クッキー詰め合わせ", introduction: "バター香る手作りクッキーのセット", image: "yakigashi01.png", genre: "ギフト・その他", price: 800 },
  { name: "プリン", introduction: "とろけるなめらか食感のカスタードプリン", image: "pudding01.png", genre: "ケーキ", price: 300 },
  { name: "カスタードタルト", introduction: "サクサク生地にたっぷりカスタード", image: "custard_tart.png", genre: "タルト・パイ", price: 300 },
  { name: "アップルパイ", introduction: "リンゴの甘酸っぱさが広がる伝統の味", image: "apple_pie.png", genre: "タルト・パイ", price: 300 },
  { name: "マカロン", introduction: "フランス風の繊細な焼き菓子", image: "macaron.png", genre: "砂糖菓子", price: 200 },
  { name: "ガトーショコラ", introduction: "しっとり濃厚なガトーショコラ", image: "gateau_chocolat.png", genre: "チョコレート菓子", price: 300 },
  { name: "キャンディ", introduction: "カラフルでどれも美味しいキャンディ", image: "candy01.png", genre: "キャンディ・飴", price: 100 }
]

item_data.each do |data|
  genre = genres.find { |g| g.name == data[:genre] } || genres.sample
  item = Item.create!(
    name: data[:name],
    introduction: data[:introduction],
    genre: genre,
    price: data[:price],
    is_active: true
  )

  image_path = Rails.root.join("app/assets/images/items/#{data[:image]}")
  if File.exist?(image_path)
    item.item_image.attach(io: File.open(image_path), filename: data[:image])
  end

  items << item
end
puts "=====商品11件を作成しました（画像付き）====="

# カートアイテム作成
customer = Customer.find(1)
3.times do
  CartItem.create!(
    customer: customer,
    item: items.sample,
    amount: 2
  )
end
puts "=====会員ID1のカートアイテムを作成しました====="

# 注文、注文明細作成
11.times do |i|
  customer = customers.sample
  order = Order.create!(
    customer: customer,
    postal_code: "0000000",
    address: customer.address,
    name: "#{customer.last_name} #{customer.first_name}",
    shipping_cost: 800,
    total_payment: 0,
    payment_method: 0,
    status: 0
  )

  if i == 10
    2.times do
      item = items.sample
      OrderDetail.create!(
        order: order,
        item: item,
        price: item.price,
        amount: 2,
        making_status: 0
      )
    end
  else
    fixed_item = items.first
    OrderDetail.create!(
      order: order,
      item: fixed_item,
      price: fixed_item.price,
      amount: 1,
      making_status: 0
    )
  end
end
puts "=====注文11件と注文明細を作成しました====="

puts "=====テストデータの作成が完了しました！====="