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

32.times do
  title = Faker::Hipster.sentence(rand(1..6))
  (rand(0..1)).times { title += " #{hashtags.sample}" }
  (rand(0..1)).times { title += " #{mentions.sample}" }
  body = Faker::Hipster.paragraph(rand(2..4))
  (rand(0..4)).times { body += " #{hashtags.sample}" }
  (rand(0..4)).times { body += " #{mentions.sample}"}

  user1.notes.create(title: title, body: body)
  user2.notes.create(title: title, body: body)
end
