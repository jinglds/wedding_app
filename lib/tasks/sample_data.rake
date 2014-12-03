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
      details = ["Package A", "Package B"]
      email = "shop@abc.com"
      approval = [true, false]
      # cover_url = ["default-s.jpg", "default-w.jpg", "default-l.jpg", "default-m.jpg", "default.jpg"]
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
                                              # cover_url: cover_url.sample,
                                              details: details.sample,
                                              website: website,
                                              description: description,
                                              approval: approval.sample
                                              ) }



    end
    2.times do
      name = ["Lovely Wedding", "Garden Engagement", "Tying the Knot", "The Vow"]
      date =  DateTime.new(2014, 11, 30, 18, 30, 00)
      time = DateTime.new(2014, 11, 30, 18, 30, 00)
      budget = 500000
      bride_name = Faker::Name.name
      groom_name = Faker::Name.name
      guest_amt = [100, 200, 150, 250, 300]
      event_type = ["Evening Party", "Budhist Ceremory","Christian Ceremony", "Chinese Ceremony"]
      users.each { |user| user.events.create!(
                                              name: name.sample,
                                              date: date,
                                              time: time,
                                              budget: budget,
                                              guest_amt: guest_amt.sample,
                                              bride_name: bride_name,
                                              groom_name: groom_name,
                                              event_type: event_type.sample
                                              ) }
    end
    events = Event.all
    30.times do
      side=["bride", "groom"]
      name = Faker::Name.name
      prefix = ["Mr.", "Mrs.", "Miss"]
      adults = [1,1,2,3]
      children = [0,0,0,0,1,2,2,3]
      phone =  Faker::PhoneNumber.cell_phone
      address = Faker::Address.city
      gender= ["Male", "Female"]
      invitation_sent=[true, true, true, false]
      via=["card", "social", "link", "others"]
      attending=[true, true, false]
      group = ["highschool", "university", "elementary", "vip", "family"]
      table_no = [0,1,2,3,4,5,6,7,8,9,10]
      note=""
      events.each { |event| event.guests.create!(
                                              side:side.sample,
                                              name:name,
                                              prefix:prefix.sample,
                                              adults:adults.sample,
                                              children:children.sample,
                                              phone:phone,
                                              address:address,
                                              gender:gender.sample,
                                              invitation_sent:invitation_sent.sample,
                                              invited_via: via.sample,
                                              attending:attending.sample,
                                              group:group.sample,
                                              table_no:table_no.sample,
                                              note:note,
                                              user_id: event.user_id
                                              ) }
    end
end
end


