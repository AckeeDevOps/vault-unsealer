require 'google/apis/cloudkms_v1'

module AckeeUnsealer
  class Decryptor
    KEY_RESOURCE = 'projects/%s/locations/%s/keyRings/%s/cryptoKeys/%s'.freeze
    API_RESOURCE = 'https://www.googleapis.com/auth/cloud-platform'.freeze

    def initialize(gcp_project:, gcp_location:, key_ring_name:, key_name:)
      @key_resource = format(
        KEY_RESOURCE,
        gcp_project,
        gcp_location,
        key_ring_name,
        key_name
      )
      initialize_sdk
    end

    def decrypt(file)
      request = Google::Apis::CloudkmsV1::DecryptRequest.new(ciphertext: file)
      response = @kms_client.decrypt_crypto_key @key_resource, request
      response.plaintext
    end

    private

    def initialize_sdk
      @kms_client = Google::Apis::CloudkmsV1::CloudKMSService.new
      @kms_client.authorization =
        Google::Auth.get_application_default(API_RESOURCE)
    end
  end
end
