require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  it 'should require a user if anonymous is false' do
    comment.anonymous = false
    expect(comment).to_not be_valid
  end
end
