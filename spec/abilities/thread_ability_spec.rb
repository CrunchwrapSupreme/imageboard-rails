require 'rails_helper'
require 'cancan/matchers'

RSpec.describe ThreadAbility do
  subject(:ability) { ThreadAbility.new(user) }
  let(:user) { nil }
  let(:board) { create(:board) }
  let(:thread) { create(:comment_thread, board_id: board.id) }

  describe 'user is site daemon' do
    let(:user) { create(:user, role: :daemon) }

    it { is_expected.to be_able_to(:read, thread) }
    it { is_expected.to be_able_to(:update, thread) }
    it { is_expected.to be_able_to(:create, CommentThread.new) }
    it { is_expected.to be_able_to(:destroy, thread) }

    it { is_expected.to be_able_to(:lock, thread) }
    it { is_expected.to be_able_to(:unlock, thread) }
    it { is_expected.to be_able_to(:sticky, thread) }

    it { is_expected.to be_able_to(:create, thread.comments.build) }
    it { is_expected.to be_able_to(:destroy, thread.comments.first) }

    context 'thread is hidden' do
      let(:thread) { create(:comment_thread, board_id: board.id, hidden: true) }
      it { is_expected.to be_able_to(:read, thread) }
    end

    context 'comment thread is sticky' do
      let(:thread) { create(:comment_thread, board_id: board.id, sticky: true) }
      it { is_expected.to be_able_to(:create, thread.comments.build) }
      it { is_expected.to be_able_to(:read, thread) }
    end

    context 'comment thread is locked' do
      let(:thread) { create(:comment_thread, board_id: board.id, locked: true) }
      it { is_expected.to be_able_to(:create, thread.comments.build) }
      it { is_expected.to be_able_to(:read, thread) }
    end
  end

  describe 'user is admin / moderator' do
    let(:user) { create(:user) }
    before(:each) do
      board.set_role(user, :admin)
    end

    it { is_expected.to be_able_to(:read, thread) }
    it { is_expected.to be_able_to(:update, thread) }
    it { is_expected.to be_able_to(:create, CommentThread.new) }
    it { is_expected.to be_able_to(:destroy, thread) }

    it { is_expected.to be_able_to(:lock, thread) }
    it { is_expected.to be_able_to(:unlock, thread) }
    it { is_expected.to be_able_to(:sticky, thread) }

    it { is_expected.to be_able_to(:create, thread.comments.build) }
    it { is_expected.to_not be_able_to(:destroy, thread.comments.first) }

    context 'thread is hidden' do
      let(:thread) { create(:comment_thread, board_id: board.id, hidden: true) }
      it { is_expected.to be_able_to(:read, thread) }
    end

    context 'comment thread is sticky' do
      let(:thread) { create(:comment_thread, board_id: board.id, sticky: true) }
      it { is_expected.to be_able_to(:create, thread.comments.build) }
      it { is_expected.to be_able_to(:read, thread) }
    end

    context 'comment thread is locked' do
      let(:thread) { create(:comment_thread, board_id: board.id, locked: true) }
      it { is_expected.to_not be_able_to(:create, thread.comments.build) }
      it { is_expected.to be_able_to(:read, thread) }
    end

    context 'comment is not #first_comment?' do
      let(:new_comment) { create(:comment, comment_thread_id: thread.id) }
      it { is_expected.to be_able_to(:destroy, new_comment) }
    end
  end

  describe 'user does not exist / has no permissions' do
    it { is_expected.to be_able_to(:read, thread) }
    it { is_expected.to be_able_to(:create, CommentThread.new) }

    it { is_expected.to_not be_able_to(:destroy, thread) }
    it { is_expected.to_not be_able_to(:update, thread) }
    it { is_expected.to_not be_able_to(:lock, thread) }
    it { is_expected.to_not be_able_to(:unlock, thread) }
    it { is_expected.to_not be_able_to(:sticky, thread) }

    context 'thread is hidden' do
      let(:thread) { create(:comment_thread, board_id: board.id, hidden: true) }
      it { is_expected.to_not be_able_to(:read, thread) }
    end

    context 'comment thread is sticky' do
      let(:thread) { create(:comment_thread, board_id: board.id, sticky: true) }
      it { is_expected.to_not be_able_to(:create, thread.comments.build) }
      it { is_expected.to be_able_to(:read, thread) }
    end

    context 'comment thread is locked' do
      let(:thread) { create(:comment_thread, board_id: board.id, locked: true) }
      it { is_expected.to_not be_able_to(:create, thread.comments.build) }
      it { is_expected.to be_able_to(:read, thread) }
    end
  end
end
