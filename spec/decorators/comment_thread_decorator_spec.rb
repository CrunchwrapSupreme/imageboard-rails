require 'rails_helper'

RSpec.describe CommentThreadDecorator do
  let(:user) { create(:user) }
  let(:comment) { create(:comment, anonymous: false, user: user) }

  context '#username' do
    it 'should return anon_name when anonymous is true' do
      comment.anonymous = true
      expect(comment.decorate.username).to eql(comment.anon_name)
    end

    it 'should return users username when anonymous is false' do
      expect(comment.decorate.username).to eql(user.username)
    end
  end
end
