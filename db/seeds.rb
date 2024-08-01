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

# SecretSubscriber

def batch_import(email, faker)
  user_1 = User.find_or_create_by(email: email)
  secrets = []
  secret_values = []
  10.times do
    secret = Secret.new(name: "#{Faker::DcComics.unique.send(faker).gsub(" ", "_")}", user: user_1)
    secrets << secret
    10.times do
      secret_values << SecretValue.new(name: Faker::Alphanumeric.unique.alpha(number: 10), value: SecureRandom.uuid, secret: secret)
    end
  end
  Secret.import secrets, validate: true
  SecretValue.import secret_values, validate: true
end

batch_import("joker@gotham.com", :villain)
batch_import("joker@gotham.com", :hero)
