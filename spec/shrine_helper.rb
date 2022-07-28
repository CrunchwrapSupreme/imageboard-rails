module TestData
  module_function

  def image_data
    attacher = Shrine::Attacher.new
    attacher.set(uploaded_image)
    attacher.set_derivatives(
      small: uploaded_image,
      medium: uploaded_image
    )

    attacher.column_data
  end

  def uploaded_image
    file = File.open(Rails.root.join('app', 'assets', 'images', 'test-pattern.webp'), binmode: true)

    uploaded_file = Shrine.upload(file, :store, metadata: false)
    uploaded_file.metadata.merge!(
      'size' => File.size(file.path),
      'mime_type' => 'image/webp',
      'filename' => 'test-pattern.webp'
    )

    uploaded_file
  end
end
