# frozen_string_literal: true

desc 'Generate Dockerfile'
task generate: :config do
  dockerfile = Boxing::Template.new('Dockerfile.tt')
  ignore = Boxing::Template.new('dockerignore.tt')
  generator = Boxing::Generator.new

  puts 'Generating Dockerfile'
  generator.execute('Dockerfile', dockerfile, context: Boxing.context.to_binding)

  puts 'Generating .dockerignore'
  generator.execute('.dockerignore', ignore, context: Boxing.context.to_binding)
end
