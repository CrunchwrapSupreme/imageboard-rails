require 'rails_helper'

RSpec.describe Board, type: :model do
  it 'should be valid with required fields' do
    board = build(:board)
    expect(board).to be_valid
  end

  context 'roles' do
    let(:test_user) { create(:user) }
    let(:board) { create(:board) }

    it 'should be able to set_role for user' do
      expect(board.set_role(test_user, :user)).to be_truthy
      expect(board.role?(test_user, :user))
    end

    it 'returns true from min_role? for user with higher role' do
      board.set_role(test_user, :moderator)
      expect(board.min_role?(test_user, :user)).to be(true)
    end

    it 'returns false from min_role? for user with lower role' do
      board.set_role(test_user, :user)
      expect(board.min_role?(test_user, :admin)).to be(false)
    end

    it 'returns true from min_role? for user with equal role' do
      board.set_role(test_user, :admin)
      expect(board.min_role?(test_user, :admin)).to be(true)
    end
  end
end
