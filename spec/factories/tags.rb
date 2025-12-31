FactoryBot.define do
  factory :tag do
    value { Faker::Lorem.words.join("-") }
  end
end
