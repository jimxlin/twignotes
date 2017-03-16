User.delete_all
Note.delete_all
Tagging.delete_all
Tag.delete_all

user = User.create(
  email: 'foobar@foobar.com',
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

  user.notes.create(title: title, body: body)
end
