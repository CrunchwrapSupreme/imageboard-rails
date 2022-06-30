require 'image_processing/mini_magick'

class ImageUploader < Shrine
  Attacher.validate do
    validate_max_size 5 * 1024 * 1024, message: 'is too large (max is 5MB)'
    validate_mime_type %w[application/png application/webp image/jpeg image/png]
    validate_extension %w[jpg jpeg png webp]
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      small: magick.resize_to_limit!(300, 300),
      medium: magick.resize_to_limit!(500, 500)
    }
  end
end
