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
    name: "Himalaya Pal",
    email: "admin@himalaya.com",
    password: "true_himalaya@123",
    role: "admin"
},
{
    name: "Anmol Shah",
    email: "admin@anmol.com",
    password: "true_anmol@123",
    role: "admin"
}
]

users.each do |user|
  User.create(user)
end

