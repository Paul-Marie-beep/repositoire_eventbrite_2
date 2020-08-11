# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

User.destroy_all
Event.destroy_all

10.times do
user = User.new(first_name: Faker::Name.first_name, last_name: Faker::Name.first_name, description: Faker::TvShows::Simpsons.quote,  email: Faker::Name.first_name+"@yopmail.com", password: "poumpoum")
user.save
puts "#{user.id} crée"
end

15.times do
event =  Event.new(
  start_date: Faker::Date.in_date_period(year: 2021, month: 5),
  duration: rand(1..10)*5,
  title: Faker::Book.title,
  description: Faker::Hipster.sentences,
  price: rand(1..1000),
  location: Faker::Address.city,
  admin: User.all.sample
)
event.save
puts "event #{event.id} crée"
end