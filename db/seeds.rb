# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.new(email: 'tester@test.com', password: 'password', password_confirmation: 'password', username: 'testtesttest')
user.skip_confirmation!
user.save!

board = Board.new(short_name: 'v', name: 'Video Games', description: 'Video game related content and discussion')
board.save!

board = Board.first
10.times do
  cthread = CommentThread.create(sticky: false, board: board)
  5.times do
    Comment.create(content: Faker::Hipster.paragraph(sentence_count: 4),
                   anonymous: false,
                   user: User.first,
                   comment_thread: cthread)

  end
end
