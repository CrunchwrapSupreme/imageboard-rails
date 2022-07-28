require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  it 'should require a user if anonymous is false' do
    comment.anonymous = false
    expect(comment).to_not be_valid
  end

  describe 'validation' do
    let(:comment) { build(:comment) }
    let(:thread) { create(:comment_thread) }
    let(:user) { create(:user) }

    it 'should strip whitespace' do
      comment.content = ' ' * 5
      expect(comment).not_to be_valid
    end

    it 'should require anon_name if anonymous' do
      comment.anonymous = true
      expect(comment).not_to be_valid
    end

    it 'should require user unless anonymous' do
      comment.anonymous = false
      comment.user = nil
      expect(comment).not_to be_valid
    end

    it 'should require comment thread' do
      comment.comment_thread = thread
      expect(comment).to be_valid
    end
  end
end
