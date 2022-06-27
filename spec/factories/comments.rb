FactoryBot.define do
  factory :comment do
    content { Faker::Hipster.sentences(number: 2) }
    anonymous { true }
    anon_name { SecureRandom.hex(6) }
    association :comment_thread
  end
end
