FactoryBot.define do
  factory :board_role do
    association :board
    association :user
    role { :user }
  end
end
