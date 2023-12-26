# frozen_string_literal: true

desc 'Generate Dockerfile'
task generate: :config do
  template('Dockerfile', 'Dockerfile.tt', context: Boxing.context)
  template('.dockerignore', 'dockerignore.tt', context: Boxing.context)
end
