# frozen_string_literal: true

task :config do
  include Boxing::Utils

  config_file = current_path.join('config', 'boxing.rb')
  load(config_file) if File.exist?(config_file)
end
