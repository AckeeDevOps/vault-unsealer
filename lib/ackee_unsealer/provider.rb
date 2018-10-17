require 'google/cloud/storage'
require_relative 'decryptor'

module AckeeUnsealer
  class Provider
    def initialize(
        project_name:,
        gcp_location:,
        key_ring_name:,
        key_name:,
        bucket_name:
      )
      @bucket_name = bucket_name
      @project_name = project_name
      @decryptor = Decryptor.new(
        gcp_project: project_name,
        gcp_location: gcp_location,
        key_ring_name: key_ring_name,
        key_name: key_name
      )
      initialize_storage
    end

    def fetch_keys(file_names:)
      keys = []
      file_names.each do |path|
        file = @bucket.file(path)
        downloaded = file.download
        downloaded.rewind
        keys << @decryptor.decrypt(downloaded.read).strip
      end
      keys
    end

    private

    def initialize_storage
      storage = Google::Cloud::Storage.new(project_id: @project_name)
      @bucket = storage.bucket(@bucket_name)
    end
  end
end
