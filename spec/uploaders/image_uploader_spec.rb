require 'rails_helper'
require 'sidekiq_helper'

RSpec.describe ImageUploader do
  let(:image) { comment.image }
  let(:comment) { create(:comment) }

  it 'extracts metadata' do
    expect(image.mime_type).to eq('image/webp')
    expect(image.extension).to eq('webp')
  end

  it 'runs PromoteJob on promotion' do
    expect { comment.image_attacher.promote_background }.to change(PromoteJob.jobs, :size).by(1)
  end

  it 'runs AttachmentDestroyJob on destroy' do
    expect { comment.image_attacher.destroy_background }.to change(AttachmentDestroyJob.jobs, :size).by(1)
  end
end
