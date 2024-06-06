# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create(email: "user_1@domain.com")

100.times do |i|
  Secret.new(name: "A_#{i}", value:  SecureRandom.hex, user: user).save!
end
user = User.create(email: "user_2@domain.com")

100.times do |i|
  Secret.new(name: "B_#{i}", value:  SecureRandom.hex, user: user).save!
end
