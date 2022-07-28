require 'rails_helper'

RSpec.describe Comments::BuildThread, type: :interactor do
  describe '.call' do
    let(:board) { create(:board) }
    
    it 'should set context.thread' do
      parameters = ActionController::Parameters.new({comment_thread: {hidden: true}})
      parameters = parameters.permit(comment_thread: [:hidden])
      result = Comments::BuildThread.call(params: parameters, board: board)
      expect(result.thread.hidden).to eql(true)
    end
  end
end
