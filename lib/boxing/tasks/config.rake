# frozen_string_literal: true

task :config do
  require 'hanami/setup' if defined?(Hanami::CLI)

  include Boxing::Utils

  config_file = current_path.join('config', 'boxing.rb')
  load config_file if config_file.exist?
end
