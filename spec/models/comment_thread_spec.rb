require 'rails_helper'

RSpec.describe CommentThread, type: :model do
  let(:board) { create(:board) }
  subject { create(:comment_thread, board_id: board.id) }

  describe 'scope' do
    it 'should scope to feed' do
      thread = create(:comment_thread, board_id: board.id)
      sticky_thread = create(:comment_thread, board_id: board.id, sticky: true)
      thread2 = create(:comment_thread, board_id: board.id)
      expect(board.threads.feed.all.map(&:id)).to eql([sticky_thread.id, thread2.id, thread.id])
    end

    it 'should scope to least_recent_first' do
      thread = create(:comment_thread, board_id: board.id)
      sticky_thread = create(:comment_thread, board_id: board.id, sticky: true)
      thread2 = create(:comment_thread, board_id: board.id)
      expect(board.threads.least_recent_first.all.map(&:id)).to eql([thread.id, sticky_thread.id, thread2.id])
    end

    it 'should scope to most_recent_first' do
      thread = create(:comment_thread, board_id: board.id)
      sticky_thread = create(:comment_thread, board_id: board.id, sticky: true)
      thread2 = create(:comment_thread, board_id: board.id)
      expect(board.threads.most_recent_first.all.map(&:id)).to eql([thread2.id, sticky_thread.id, thread.id])
    end
  end

  it 'should increase bump count on comment add' do
    last_count = subject.bump_count
    last_bump = subject.last_bump
    subject.comments << create(:comment, comment_thread: subject)
    expect(subject.last_bump).not_to eql(last_bump)
    expect(subject.bump_count).to eql(last_count + 1)
  end

  describe 'locked' do
    it 'should #lock and persist' do
      subject.lock
      expect(subject.locked).to eql(true)
    end

    it 'should #unlock and persist' do
      subject.unlock
      expect(subject.locked).to eql(false)
    end
  end

  describe 'hide' do
    it 'should #hide and persist' do
      subject.hide
      expect(subject.hidden).to eql(true)
    end

    it 'should #unhide and persist' do
      subject.unhide
      expect(subject.hidden).to eql(false)
    end
  end

  it { should belong_to(:board) }
  it { should have_many(:comments) }
end
