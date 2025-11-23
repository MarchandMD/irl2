# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

# Create users if they don't exist
puts "Creating users..."
10.times do
  User.find_or_create_by!(email: Faker::Internet.unique.email) do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end
end

# Create 100 tasks
puts "Creating tasks..."
users = User.all
statuses = ["open", "in_progress", "completed", "closed"]

100.times do
  Task.create!(
    title: Faker::Lorem.sentence(word_count: 3),
    description: Faker::Lorem.paragraph(sentence_count: 3),
    status: statuses.sample,
    user: users.sample,
    upvotes_count: rand(0..50),
    submissions_count: rand(0..10)
  )
end

puts "Seed data created: #{User.count} users and #{Task.count} tasks"
