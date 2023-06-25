# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a main sample user.

users = [
  {
    name: 'Melon Musk',
    email: 'admin@melon.com',
    password: 'true_melon@123',
    password_confirmation: 'true_melon@123',
    role: 'admin'
  },
  {
    name: 'Jack Ma',
    email: 'admin@jack.com',
    password: 'true_jack@123',
    password_confirmation: 'true_jack@123',
    role: 'admin'
  }
]

users.each do |user|
  User.create(user)
end
