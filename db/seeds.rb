User.delete_all
Note.delete_all
Tagging.delete_all
Tag.delete_all

user1 = User.create(
  email: 'foobar@foobar.com',
  password: 'foobar',
  password_confirmation: 'foobar'
)

user2 = User.create(
  email: 'foobaz@foobaz.com',
  password: 'foobar',
  password_confirmation: 'foobar'
)

hashtags = []
8.times { hashtags << '#' + Faker::Hipster.word }
mentions = []
8.times { mentions << '@' + Faker::Name.first_name}

# User1

28.times do
  title = ""
  (rand(0..1)).times { title += " #{hashtags.sample}" }
  (rand(0..1)).times { title += " #{mentions.sample}" }
  title += [true, false].sample ? "" : Faker::Hipster.sentence(rand(1..3), false, 0)

  body = ""
  (rand(0..4)).times { body += " #{hashtags.sample}" }
  (rand(0..4)).times { body += " #{mentions.sample}"}
  body += Faker::Hipster.paragraph(rand(1..3))

  user1.notes.create(title: title, body: body)
end

4.times do
  title = [true, false].sample ? "" : Faker::Hipster.sentence(rand(1..3), false, 0)
  body = Faker::Hipster.paragraph(rand(1..3))

  user1.notes.create(title: title, body: body)
end

# User2

28.times do
  title = ""
  (rand(0..1)).times { title += " #{hashtags.sample}" }
  (rand(0..1)).times { title += " #{mentions.sample}" }
  title += [true, false].sample ? "" : Faker::Hipster.sentence(rand(1..3), false, 0)
  
  body = ""
  (rand(0..4)).times { body += " #{hashtags.sample}" }
  (rand(0..4)).times { body += " #{mentions.sample}"}
  body += Faker::Hipster.paragraph(rand(1..3))

  user2.notes.create(title: title, body: body)
end

4.times do
  title = [true, false].sample ? "" : Faker::Hipster.sentence(rand(1..3), false, 0)
  body = Faker::Hipster.paragraph(rand(1..3))

  user2.notes.create(title: title, body: body)
end
