require 'rails_helper'
require 'cancan/matchers'

RSpec.describe BoardAbility do
  subject(:ability) { BoardAbility.new(user) }
  let(:user) { nil }
  let(:board) { create(:board) }

  context 'user is site daemon' do
    let(:user) { create(:user, role: :daemon) }

    it { is_expected.to be_able_to(:read, board) }
    it { is_expected.to be_able_to(:update, board) }
    it { is_expected.to be_able_to(:create, Board.new) }
    it { is_expected.to be_able_to(:destroy, board) }
  end

  context 'user is admin' do
    let(:user) { create(:user) }
    before(:each) do
      board.set_role(user, :admin)
    end

    it { is_expected.to_not be_able_to(:create, Board.new) }
    it { is_expected.to be_able_to(:read, board) }
    it { is_expected.to be_able_to(:update, board) }
    it { is_expected.to_not be_able_to(:destroy, board) }
  end

  context 'user is owner' do
    let(:user) { create(:user) }
    before(:each) do
      board.set_role(user, :owner)
    end

    it { is_expected.to_not be_able_to(:create, Board.new) }
    it { is_expected.to be_able_to(:read, board) }
    it { is_expected.to be_able_to(:update, board) }
    it { is_expected.to be_able_to(:destroy, board) }
  end

  context 'not a user / has no permissions' do
    let(:user) { create(:user, role: :user) }

    it { is_expected.to be_able_to(:read, board) }
    it { is_expected.to_not be_able_to(:update, board) }
    it { is_expected.to_not be_able_to(:create, Board.new) }
    it { is_expected.to_not be_able_to(:destroy, board) }
  end
end
