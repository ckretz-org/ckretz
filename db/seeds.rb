# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

RLS.disable!

SecretSubscriber

user_1 = User.find_or_create_by(email: "joker@gotham.com")
100.times do |i|
  Secret.new(name: "#{Faker::DcComics.villain}-#{Random.rand(10000)}", user: user_1).save!
end

user_2 = User.find_or_create_by(email: "batman@gothan.com")
100.times do |i|
  Secret.new(name: "#{Faker::DcComics.hero}-#{Random.rand(10000)}", user: user_2).save!
end
