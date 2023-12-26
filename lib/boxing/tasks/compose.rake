# frozen_string_literal: true

desc 'Generate docker-compose.yml'
task compose: :config do
  template('docker-compose.yml', 'docker-compose.yml.tt', context: Boxing.context)
end
