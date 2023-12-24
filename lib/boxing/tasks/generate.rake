# frozen_string_literal: true

desc 'Generate Dockerfile'
task generate: :config do
  include Boxing::Utils

  puts 'Generating Dockerfile'
  template('Dockerfile', 'Dockerfile.tt', context: Boxing.context)

  puts 'Generating .dockerignore'
  template('.dockerignore', 'dockerignore.tt', context: Boxing.context)
end
