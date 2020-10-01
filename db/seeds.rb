# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create!(
  [
    {email: 'olivia@test.com', name: 'Olivia', introduction: 'Hello!!', password: 'password', profile_image: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg")},
    {email: 'james@test.com', name: 'James', introduction: 'Hello!!', password: 'password', profile_image: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg")},
    {email: 'lucas@test.com', name: 'Lucas', introduction: 'Hello!!', password: 'password', profile_image: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg")}
  ]
)

Book.create!(
  [
    {title: 'リーダブルコード', body: 'より良いコードを書くためのシンプルで実践的なテクニック。', user_id: users[0].id },
    {title: 'トラブル知らずのシステム設計', body: 'システム設計の要点を図解で説明してくれます。', user_id: users[1].id },
    {title: 'たのしいRuby', body: 'Rubyの入門におすすめです。', user_id: users[2].id },
  ]
)