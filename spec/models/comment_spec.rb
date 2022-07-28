require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { create(:comment) }

  it 'should require a user if anonymous is false' do
    subject.anonymous = false
    is_expected.to_not be_valid
  end

  describe 'validation' do
    subject { build(:comment, anonymous: false, user: user) }
    let(:thread) { create(:comment_thread) }
    let(:user) { create(:user) }

    it 'should strip whitespace' do
      subject.content = ' ' * 5
      is_expected.not_to be_valid
    end

    it { should validate_presence_of(:user_id) }
    it { should_not validate_presence_of(:anon_name) }

    context 'anonymous' do
      before(:each) { subject.anonymous = true }

      it { should validate_length_of(:anon_name).is_equal_to(12) }
      it { should_not validate_presence_of(:user_id) }
      it { should validate_presence_of(:anon_name) }
    end

    it 'should require comment thread' do
      subject.comment_thread = thread
      is_expected.to be_valid
    end
  end

  it { should validate_length_of(:content).is_at_least(3) }
  it { should validate_length_of(:content).is_at_most(1024) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:comment_thread_id) }
  it { should belong_to(:comment_thread) }q

  context 'first comment' do
    subject { create(:comment_thread).comments.least_recent_first.first }

    it { should validate_presence_of(:image) }
    it { expect(subject.first_comment?).to be(true) }
  end

  context 'not first comment' do
    subject { create(:comment_thread).comments.build }

    it { should_not validate_presence_of(:image) }
    it { expect(subject.first_comment?).to be(false) }
  end
end
