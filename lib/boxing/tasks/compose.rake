# frozen_string_literal: true

desc 'Generate docker-compose.yml'
task compose: :config do
  include Boxing::Utils

  puts 'Generating docker-compose.yml'
  template('docker-compose.yml', 'docker-compose.yml.tt', context: Boxing.context)
end
