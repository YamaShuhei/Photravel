# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# #管理者用情報の初期設定
Admin.create!(
   email: "admin@admin",
   password: "testtest"
 )
 
 User.create!(
    email: "test_user@test.com",
    password: SecureRandom.urlsafe_base64,
    name: "ゲストユーザー",
    introduction: "ゲストユーザーの自己紹介文です"
    )
