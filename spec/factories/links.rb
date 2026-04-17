FactoryBot.define do
  factory :link do
    target_url { Faker::Internet.url }
  end
end
