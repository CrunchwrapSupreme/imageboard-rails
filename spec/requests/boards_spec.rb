require 'rails_helper'

RSpec.describe BoardsController, type: :request do
  let(:test_user) { create(:user) }
  let(:test_board) { create(:board) }

  describe 'GET #index' do
    it 'should be accessible to non-users' do
      create(:board)
      get boards_url
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('/v/')

      get "#{boards_url}.json"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Video Games')
      expect { JSON.parse(response.body) }.not_to raise_exception
    end

    it 'should be accessible by users' do
      create(:board)
      sign_in(test_user)
      get boards_url
      expect(response).to have_http_status(:ok)
      get "#{boards_url}.json"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'should be accessible by site daemons' do
      test_user.role = :daemon
      test_user.save
      sign_in(test_user)
      get edit_board_url(test_board)
      expect(response).to have_http_status(:ok)
    end

    it 'should be accessible by board moderators' do
      test_board.set_role(test_user, :moderator)
      sign_in(test_user)
      get edit_board_url(test_board)
      expect(response).to have_http_status(:ok)
    end

    it 'should not be accessible by regular users' do
      sign_in(test_user)
      get edit_board_url(test_board)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Unauthorized')
    end
  end

  describe 'GET #show' do
    it 'should be accessible by non-users and users alike' do
      get board_url(test_board)
      expect(response).to have_http_status(:ok)
      sign_in(test_user)
      get board_url(test_board)
      expect(response).to have_http_status(:ok)

      get "#{board_url(test_board)}.json"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Video Games')
      expect { JSON.parse(response.body) }.not_to raise_exception
    end
  end

  describe 'GET #new' do
    it 'should not be accessible by regular users' do
      sign_in(test_user)
      get new_board_url(test_board)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Unauthorized')
    end

    it 'should be accessible by site daemons' do
      test_user.role = :daemon
      test_user.save
      sign_in(test_user)
      get new_board_url(test_board)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'should not be accessible by board users' do
      sign_in(test_user)
      post boards_url
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Unauthorized')
    end

    it 'should be accessible by site daemons' do
      test_user.role = :daemon
      test_user.save
      sign_in(test_user)
      post boards_url, params: { board: { short_name: 'c', name: 'cart', description: 'test' } }
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Successfully created board')
    end
  end

  describe 'PUT #update' do
    it 'should not be edited by regular users' do
      sign_in(test_user)
      put board_url(test_board), params: {
        board: {
          short_name: 'c',
          name: 'cart',
          description: 'test'
        }
      }
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Unauthorized')
    end

    it 'should be edited by board moderators' do
      test_board.set_role(test_user, :moderator)
      sign_in(test_user)
      put board_url(test_board), params: {
        board: {
          short_name: 'c',
          name: 'cart',
          description: 'test'
        }
      }
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Successfully updated board')
      test_board.reload
      expect(test_board.short_name).to eql('v')
      expect(test_board.name).to eql('cart')
      expect(test_board.description).to eql('test')
    end
  end

  describe 'DELETE #destroy' do
    it 'should not be deleted by regular users' do
      sign_in(test_user)
      delete board_url(test_board)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Unauthorized')
    end

    it 'should be deleted by board owner' do
      test_board.set_role(test_user, :owner)
      sign_in(test_user)
      delete board_url(test_board)
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Board deleted')
      expect(Board.count).to eql(0)
    end
  end
end
