# frozen_string_literal: true

require 'zeitwerk'

# The tool to generate Dockerfile without config
#
# @since 0.1.0
module Boxing
  LOCK = Mutex.new

  module_function

  # @since 0.11.0
  # @api private
  def loader
    @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      loader.ignore("#{__dir__}/boxing/{railtie,hanami}.rb")
    end
  end

  loader.setup

  require_relative 'boxing/railtie' if defined?(Rails::Railtie)
  require_relative 'boxing/hanami' if defined?(Hanami::CLI)

  # @return [Bundler::Dependency]
  #
  # @since 0.1.0
  def dependencies(groups = %i[default production])
    Bundler
      .definition
      .current_dependencies
      .select { |dep| (dep.groups & groups).any? }
  end

  # @return [Boxing::Config]
  #
  # @since 0.5.0
  def config(&block)
    return @config if @config

    LOCK.synchronize do
      return @config if @config

      @config = Config.new(&block)
    end

    @config
  end
end
