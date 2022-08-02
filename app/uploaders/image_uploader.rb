require 'image_processing/mini_magick'

class ImageUploader < Shrine
  Attacher.validate do
    validate_max_size 5 * 1024 * 1024, message: 'is too large (max is 5MB)'
    validate_extension %w[jpg jpeg png webp]
    return unless validate_mime_type %w[application/png application/webp image/jpeg image/png]

    validate_max_dimensions [2500, 2500]
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small: magick.resize_to_limit!(300, 300),
      medium: magick.resize_to_limit!(500, 500)
    }
  end

  Attacher.promote_block do
    PromoteJob.perform_async(self.class.name, record.class.name, record.id, name, file_data)
  end

  Attacher.destroy_block do
    AttachmentDestroyJob.perform_async(self.class.name, data)
  end
end
