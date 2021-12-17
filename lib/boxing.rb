# frozen_string_literal: true

require_relative 'boxing/version'
require_relative 'boxing/package'
require_relative 'boxing/database'
require_relative 'boxing/command'

# The tool to generate Dockerfile without config
#
# @since 0.1.0
module Boxing
  module_function

  # @return [Bundler::Dependency]
  #
  # @since 0.1.0
  def dependencies(groups = %i[default production])
    Bundler
      .definition
      .current_dependencies
      .select { |dep| (dep.groups & groups).any? }
  end
end
