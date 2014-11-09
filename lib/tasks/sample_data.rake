namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(firstname: "Ladasa",
                lastname: "Tiraviryapol",
                address: "Bangkok",
                phone: "0855081078",
                role: "admin",
                 email: "jinpeko@gmail.com",
                 password: "jingjing",
                 password_confirmation: "jingjing",
                 approval: "f")
    User.create!(firstname: "Guy",
                lastname: "Srithongchai",
                address: "Bangkok",
                phone: "12345678",
                role: "admin",
                 email: "guysri@email.com",
                 password: "12345678",
                 password_confirmation: "12345678",
                 approval: "f")
    66.times do |n|
      firstname  = Faker::Name.first_name
      lastname  = Faker::Name.last_name
      address = Faker::Address.city
      phone = Faker::PhoneNumber.cell_phone
      role = "client"
      email = "example-#{n+1}@abc.com"
      password  = "password"
      approval = ["f", "t"]
      User.create!(firstname: firstname,
                   lastname: lastname,
                   address: address,
                   phone: phone,
                   role: role,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   approval: approval.sample)
    end
    33.times do |n|
      firstname  = Faker::Name.first_name
      lastname  = Faker::Name.last_name
      address = Faker::Address.city
      phone = Faker::PhoneNumber.cell_phone
      role = "enterprise"
      email = "example-#{n+1+66}@abc.com"
      password  = "password"
      User.create!(firstname: firstname,
                   lastname: lastname,
                   address: address,
                   phone: phone,
                   role: role,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   approval: "f")
    end
    users = User.all
    2.times do
      name = Faker::Company.name
      phone =  Faker::PhoneNumber.cell_phone
      address = Faker::Address.city
      details = ["auto", "non-auto"]
      email = "shop@abc.com"
      cover_url = ["default-s.jpg", "default-w.jpg", "default-l.jpg", "default-m.jpg", "default.jpg"]
      category_list = ["attire, music", "photography, card", "music, decoration, photography", "decoration, attire", "photography"]
      style_list =["vintage, beauty, classic", "luxury, classic", "vintage", "modern, pop", "modern, luxury", "beauty, modern", "pastel, light", "beauty, modern, creative"]
      description = Faker::Lorem.sentence(3)
      website = Faker::Internet.domain_name
      users.each { |user| user.shops.create!(
                                              name: name,
                                              category_list: category_list.sample,
                                              style_list: style_list.sample,
                                              email: email,
                                              phone: phone,
                                              address: address,
                                              cover_url: cover_url.sample,
                                              details: details.sample,
                                              website: website,
                                              description: description
                                              ) }



    end
    2.times do
      name = Faker::Name.name
      date =  DateTime.new(2014, 11, 30, 18, 30, 00)
      time = DateTime.new(2014, 11, 30, 18, 30, 00)
      budget = 500000
      bride_name = Faker::Name.name
      groom_name = Faker::Name.name
      event_type = ["Evening Party", "Budhist Ceremory","Christian Ceremony", "Chinese Ceremony"]
      users.each { |user| user.events.create!(
                                              name: name,
                                              date: date,
                                              time: time,
                                              budget: budget,
                                              bride_name: bride_name,
                                              groom_name: groom_name,
                                              event_type: event_type.sample
                                              ) }
    end
  end
end


