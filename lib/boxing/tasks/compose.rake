# frozen_string_literal: true

desc 'Generate docker-compose.yml'
task compose: :config do
  compose = Boxing::Template.new('docker-compose.yml.tt')
  generator = Boxing::Generator.new
  context = Boxing::Context.new(
    Boxing.config,
    Boxing::Database.new,
    Boxing.dependencies
  )

  puts 'Generating docker-compose.yml'
  generator.execute('docker-compose.yml', compose, context: context.to_binding)
end
