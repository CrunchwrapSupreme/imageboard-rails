require 'rails_helper'

RSpec.describe CommentThread, type: :model do
  let(:board) { create(:board) }
  let(:cthread) { create(:comment_thread, board_id: board.id) }

  context 'scope' do
    it 'should return an ordered feed' do
      thread = create(:comment_thread, board_id: board.id)
      sticky_thread = create(:comment_thread, board_id: board.id, sticky: true)
      thread2 = create(:comment_thread, board_id: board.id)

      expect(board.threads.feed.all.map(&:id)).to eql([sticky_thread.id, thread2.id, thread.id])
    end
  end

  it 'should increase bump count on touch' do
    last_count = cthread.bump_count
    last_bump = cthread.last_bump
    cthread.touch
    expect(cthread.last_bump).not_to eql(last_bump)
    expect(cthread.bump_count).to eql(last_count + 1)
  end

  it 'should not allow sticky to be nil' do
    cthread.sticky = nil
    expect(cthread).not_to be_valid
  end
end
