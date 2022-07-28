require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  it 'should be valid with required fields' do
    user = build(:user)
    expect(user).to be_valid
  end

  describe 'roles' do
    let(:test_user) { create(:user) }

    it 'should have a default role of user' do
      expect(test_user.role).to eql(:user)
    end

    it 'should allow role to be changed' do
      test_user.role = :daemon
      expect(test_user.role).to eql(:daemon)
    end

    it 'should satisfy min_role? with higher role' do
      test_user.role = :daemon
      expect(test_user.min_role?(:user)).to be(true)
      expect(test_user.min_role?(:daemon)).to be(true)
    end

    it 'should not satisfy min_role? with lower role' do
      expect(test_user.min_role?(:daemon)).to be(false)
    end
  end

  it { should have_many(:comments) }
  it { should have_many(:boards) }
  it { should have_many(:board_roles) }
  it { should validate_presence_of(:username) }
  it { should validate_length_of(:username).is_at_least(1) }
  it { should validate_length_of(:username).is_at_most(12) }

  describe 'username' do
    it 'should only accept usernames with digits, numbers, underscores, and -' do
      subject.username = 'abc-_'
      is_expected.to be_valid
    end

    it 'should not accept special characters' do
      subject.username = 'test@'
      is_expected.to_not be_valid
    end
  end
end
