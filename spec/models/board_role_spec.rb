require 'rails_helper'

RSpec.describe BoardRole, type: :model do
  subject { create(:board_role) }

  it { should belong_to(:user) }
  it { should belong_to(:board) }  
  it { should validate_presence_of(:board_id) }
  it { should validate_presence_of(:user_id) }

  describe '#role=' do
    it 'should require a valid role' do
      expect { subject.role = 0 }.to raise_error
      expect { subject.role = :random_crap }.to raise_error
    end

    it 'should accept a valid role' do
      expect { subject.role = :admin }.to_not raise_error
      expect { subject.role = :moderator }.to_not raise_error
      expect { subject.role = :owner }.to_not raise_error
      expect { subject.role = :user }.to_not raise_error
    end
  end

  describe '#min_role?' do
    it 'should return true if stored role is greater than provided role' do
      subject.role = :owner
      expect(subject.min_role?(:user)).to be(true)
    end
    
    it 'should return true if stored role is equal to provided role' do
      expect(subject.min_role?(:user)).to be(true)
    end

    it 'should return false if stored role is greater than provided role' do
      expect(subject.min_role?(:admin)).to be(false)
    end

    it 'should throw for invalid role' do
      expect { subject.min_role?(:nonsense) }.to raise_error
    end
  end
end
