FactoryBot.define do
  factory :comment do
    content { Faker::Hipster.sentences(number: 2).join(' ') }
    anonymous { true }
    anon_name { SecureRandom.hex(6) }
    association :comment_thread
    image_data { TestData.image_data }

    trait :has_user do
      anonymous { false }
      association :user
    end
  end
end
