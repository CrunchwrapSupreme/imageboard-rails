require 'rails_helper'

RSpec.describe BoardDecorator do
  let(:board) { create(:board, short_name: 'tst') }

  context '#slash_name' do
    it 'should generate a slash name' do
      expect(board.decorate.slash_name).to eql('/tst/')
    end
  end
end
