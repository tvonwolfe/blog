FactoryBot.define do
  factory :tag, class: "Tag" do
    value { Faker::Lorem.words.join("-") }
  end
end
