FactoryBot.define do
  factory :post, class: "Post" do
    title { Faker::Lorem.sentence }
    published_at { nil }
    content { Faker::Lorem.paragraphs(number: 3).join("\n\n") }

    trait :tagged do
      after(:build) do |post, evaluator|
        post.tags = build_list(:tag, 1)
      end
    end

    trait :published do
      published_at { DateTime.current }
    end
  end
end
