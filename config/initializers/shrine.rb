require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/storage/memory'

Shrine.storages = if Rails.env.test?
                    {
                      cache: Shrine::Storage::Memory.new,
                      store: Shrine::Storage::Memory.new
                    }
                  else
                    {
                      cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
                      store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
                    }
                  end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data    # re-extract metadata when attaching a cached file
Shrine.plugin :validation             # validation in uploader
Shrine.plugin :validation_helpers
Shrine.plugin :derivatives            # create thumbnails
Shrine.plugin :determine_mime_type
Shrine.plugin :remove_invalid
Shrine.plugin :restore_cached_data
Shrine.plugin :store_dimensions
