FactoryBot.define do
  factory :comment_thread do
    sticky { false }

    after :create do |thread|
      create_list :comment, 3, comment_thread: thread
      thread.bump_count = 3
      thread.save
    end

    association :board
  end
end
