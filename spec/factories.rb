FactoryGirl.define do
  factory :tagging do
    
  end
  factory :tag do
    
  end
  factory :user do
    sequence :email do |n|
      "foobar-#{n}@foobar.com"
    end
    password "foobar"
    password_confirmation "foobar"
  end

  factory :note do
    title "TitleText"
    body "BodyText"
    association :user
  end
end
