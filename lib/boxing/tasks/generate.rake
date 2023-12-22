# frozen_string_literal: true

desc 'Generate Dockerfile'
task generate: :config do
  dockerfile = Boxing::Template.new('Dockerfile.tt')
  ignore = Boxing::Template.new('dockerignore.tt')
  generator = Boxing::Generator.new
  context = Boxing::Context.new(
    Boxing.config,
    Boxing::Database.new,
    Boxing.dependencies
  )

  puts 'Generating Dockerfile'
  generator.execute('Dockerfile', dockerfile, context: context.to_binding)

  puts 'Generating .dockerignore'
  generator.execute('.dockerignore', ignore, context: context.to_binding)
end
