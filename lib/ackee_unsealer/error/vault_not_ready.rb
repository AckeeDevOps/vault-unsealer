module AckeeUnsealer
  module Error
    class VaultNotReady < StandardError
      def initialize(msg = 'Vault is not ready')
        super(msg)
      end
    end
  end
end
