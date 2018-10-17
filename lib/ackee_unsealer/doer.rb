require 'vault'
require_relative 'error/vault_not_ready'

module AckeeUnsealer
  class Doer
    MESSAGE_UNSEALED =              'Vault %s is already unsealed'.freeze
    MESSAGE_SEALED_START =          'Vault %s is sealed. Unsealing...'.freeze
    MESSAGE_UNSEAL_PROGRESS =       'Unseal status: total: %d, '\
                                    'treshold: %d, progress: %d'.freeze
    MESSAGE_UNSEAL_DONE =           'Vault %s has been unsealed.'.freeze
    MESSAGE_UNSEAL_UNSUCCESSFUL =   'Vault %s has not been unsealed. '\
                                    'I do not know why :('.freeze

    def initialize(vault_url:, logger:)
      @vault_url = vault_url
      @logger = logger
      initialize_vault_client
    end

    def check(keys:)
      if @client.sys.seal_status.sealed?
        @logger.info(format(MESSAGE_SEALED_START, @vault_url))
        keys.each do |key|
          break unless process_result(result: @client.sys.unseal(key))
        end
        check_final_status
      else
        @logger.info(format(MESSAGE_UNSEALED, @vault_url))
      end
    end

    private

    def initialize_vault_client
      @client = Vault::Client.new(address: @vault_url)
      check_init_status
    end

    def check_init_status
      raise Error::VaultNotReady 'Vault is not initialized' unless
        @client.sys.init_status.initialized?
    end

    def process_result(result:)
      m = format(MESSAGE_UNSEAL_PROGRESS, result.n, result.t, result.progress)
      @logger.info(m)
      result.sealed?
    end

    def check_final_status
      if @client.sys.seal_status.sealed?
        @logger.warn(format(MESSAGE_UNSEAL_UNSUCCESSFUL, @vault_url))
      else
        @logger.info(format(MESSAGE_UNSEAL_DONE, @vault_url))
      end
    end
  end
end
