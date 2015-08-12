# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
56.times do |n|
    name = Faker::Name.name
    company = "example#{n%10}"
    email = "example-#{n}@#{company}.com"
    password = "password"
    user=User.create!(name: name,
                  email: email,
                  password: password,
                  password_confirmation: password)

    date = DateTime.now
    Lunch.create(day: date.strftime("%Y/%m/%d"), name: company, user_id: user.id) if date.strftime("%a") != "Sun" && date.strftime("%a") != "Sat"

end

