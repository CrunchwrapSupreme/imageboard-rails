require 'rails_helper'

RSpec.describe Board, type: :model do
  subject { create(:board) }
  
  context 'roles' do
    let(:test_user) { create(:user) }

    it 'should be able to set_role for user' do
      expect(subject.set_role(test_user, :user)).to be_truthy
      expect(subject.role?(test_user, :user))
    end

    it 'returns true from min_role? for user with higher role' do
      subject.set_role(test_user, :moderator)
      expect(subject.min_role?(test_user, :user)).to be(true)
    end

    it 'returns false from min_role? for user with lower role' do
      subject.set_role(test_user, :user)
      expect(subject.min_role?(test_user, :admin)).to be(false)
    end

    it 'returns true from min_role? for user with equal role' do
      subject.set_role(test_user, :admin)
      expect(subject.min_role?(test_user, :admin)).to be(true)
    end
  end

  describe '#to_param' do
    it 'should return short_name' do
      expect(subject.to_param).to eq(subject.short_name)
    end
  end

  it { should validate_length_of(:short_name).is_at_least(1) }
  it { should validate_length_of(:short_name).is_at_most(4) }
  it { should validate_presence_of(:short_name) }

  it { should validate_length_of(:name).is_at_least(1) }
  it { should validate_length_of(:name).is_at_most(16) }
  it { should validate_presence_of(:name) }

  it { should validate_length_of(:description).is_at_most(128) }
  it { should have_many(:threads) }
  it { should have_many(:board_roles) }
  it { should have_many(:users) }
end
