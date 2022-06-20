FactoryBot.define do
  factory :user do
    email { 'tester@test.com' }
    password { 'password1' }
    password_confirmation { 'password1' }
    before(:create, &:skip_confirmation!)

    trait :daemon do
      before(:create, role: :daemon)
    end

    trait :owner do
      before(:create, role: :owner)
    end
  end
end
