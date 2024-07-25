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
10.times do |i|
  secret = Secret.new(name: "#{Faker::DcComics.unique.villain.gsub(" ", "_")}", user: user_1)
  secret.save!
  secret.secret_values << SecretValue.new(name: Faker::Alphanumeric.unique.alpha(number: 10), value: SecureRandom.uuid)
  secret.secret_values << SecretValue.new(name: Faker::Alphanumeric.unique.alpha(number: 10), value: SecureRandom.uuid)
end

user_2 = User.find_or_create_by(email: "batman@gothan.com")
10.times do |i|
  secret = Secret.new(name: "#{Faker::DcComics.unique.hero.gsub(" ", "_")}", user: user_2)
  secret.save!
  secret.secret_values << SecretValue.new(name: Faker::Alphanumeric.unique.alpha(number: 10), value: SecureRandom.uuid)
end
