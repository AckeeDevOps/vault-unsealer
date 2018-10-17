require 'dotenv/tasks'

task default: :run

task run: :dotenv do
  ruby 'lib/ackee_unsealer.rb'
end

task :docker_build do
  sh 'docker build -t ackee-vault-unsealer .'
  sh 'docker tag ackee-vault-unsealer eu.gcr.io/'\
  'ackee-production/ackee-vault-unsealer'
  sh 'docker push eu.gcr.io/ackee-production/ackee-vault-unsealer'
end
