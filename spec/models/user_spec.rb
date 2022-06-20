require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should be valid with required fields' do
    user = build(:user)
    expect(user).to be_valid
  end

  context 'roles' do
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
end
