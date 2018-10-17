require_relative 'provider'
require_relative 'doer'

module AckeeUnsealer
  class Runner
    attr_accessor :project_name,
                  :gcp_location,
                  :key_ring_name,
                  :key_name,
                  :bucket_name,
                  :vault_url,
                  :file_names,
                  :logger

    def initialize
      @logger = Logger.new(STDOUT)
    end

    def run
      initialize_provider
      doer = Doer.new(vault_url: @vault_url, logger: @logger)
      keys = @provider.fetch_keys(file_names: @file_names)
      doer.check(keys: keys)
    end

    private

    def initialize_provider
      @provider = Provider.new(
        project_name: @project_name,
        gcp_location: @gcp_location,
        key_ring_name: @key_ring_name,
        key_name: @key_name,
        bucket_name: @bucket_name
      )
    end
  end
end
