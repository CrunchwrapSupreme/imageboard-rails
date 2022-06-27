require 'rails_helper'

RSpec.describe "CommentThreads", type: :request do
  let(:board) { create(:board, short_name: 'tst') }
  let(:thread) { create(:comment_thread, board: board) }
  let(:user) { create(:user, :daemon) }
  describe 'DELETE /boards/:board/threads/:id' do
    it 'returns http success for daemon user' do
      sign_in user
      delete board_comment_thread_url(board, thread)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include('destroyed')
    end

    it 'redirects for user' do
      user.role = :user
      board.set_role(user, :user)
      user.save!
      sign_in user
      delete board_comment_thread_url(board, thread)
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Unauthorized')
    end
  end

  describe 'GET /boards/:board/threads/:id' do
    it 'returns http success' do
      get board_comment_thread_url(board, thread)
      expect(response).to have_http_status(:success)
    end
  end
end
