require_relative 'ackee_unsealer/runner'
require 'pry'

runner = AckeeUnsealer::Runner.new
runner.project_name = ENV['GCP_PROJECT_NAME']
runner.gcp_location = ENV['GCP_KEY_RING_LOCATION']
runner.key_ring_name = ENV['GCP_KEY_RING_NAME']
runner.key_name = ENV['GCP_KEY_NAME']
runner.bucket_name = ENV['GCP_STORAGE_BUCKET_NAME']
runner.vault_url = ENV['VAULT_ADDR']
runner.file_names = ENV['VAULT_KEYS_FILE_NAMES'].split(',')
runner.run
