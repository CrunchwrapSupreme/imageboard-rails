require 'rails_helper'
require 'sidekiq_helper'

RSpec.describe ImageUploader do
  let(:image) { comment.image }
  let(:comment) { create(:comment, :cached_file) }

  it 'extracts metadata' do
    expect(image.mime_type).to eq('image/webp')
    expect(image.extension).to eq('webp')
  end

  it 'runs PromoteJob on promotion' do
    expect { comment.image_attacher.promote_background }.to change(PromoteJob.jobs, :size).by(1)
    PromoteJob.drain
    expect(comment.reload.image_attacher.cached?).to eql(false)
  end

  it 'runs AttachmentDestroyJob on destroy' do
    expect { comment.image_attacher.destroy_background }.to change(AttachmentDestroyJob.jobs, :size).by(1)
    AttachmentDestroyJob.drain
    expect(comment.image.exists?).to eql(false)
  end
end
