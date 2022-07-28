require 'rails_helper'

RSpec.describe Comments::Persist, type: :interactor do
  describe '.call' do
    let(:thread) { create(:comment_thread) }
    let(:user) { create(:user) }
    let(:params) { ActionController::Parameters.new({comment: {content: 'test'}}) }
    let(:result) do
      parameters = params.permit(comment: [:content])
      Comments::Persist.call(params: parameters, thread: thread, user: user)
    end

    it 'should create user comment and bump thread' do
      expect(result.comment).to be_valid
      expect(result.comment.user).to eql(user)
      expect(result.thread.bump_count).to eql(4)
      expect(result.success?).to eql(true)
    end

    it 'should resolve with error message for invalid authorization state' do
      thread.hidden = true
      expect(result.success?).to eql(false)
    end

    context 'invalid comment parameters' do
      let(:params) { ActionController::Parameters.new({ comment: { content: '' } }) }

      it 'should resolve with error message for invalid comment' do
        expect(result.success?).to eql(false)
      end
    end

    context 'user is anonymous' do
      let(:anon_name) { SecureRandom.hex(6) }
      let(:result) do
        parameters = params.permit(comment: [:content])
        Comments::Persist.call(params: parameters, thread: thread, anon_name: anon_name)
      end

      it 'should create anonymous comment and bump thread' do
        expect(result.comment).to be_valid
        expect(result.comment.anon_name).to eql(anon_name)
        expect(result.thread.bump_count).to eql(4)
        expect(result.success?).to eql(true)
      end
    end
  end
end
