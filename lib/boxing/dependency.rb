# frozen_string_literal: true

module Boxing
  # The dependency of project
  #
  # @since 0.1.0
  class Dependency
    # NOTE: Current only support to create for production
    #
    # @since 0.1.0
    DEFAULT_GROUPS = %i[default production].freeze

    # @param dependencies [Array<Bundler::Dependency>]
    #
    # @since 0.1.0
    def initialize(dependencies = [])
      @dependencies = dependencies
    end

    # Filter desired rubygems
    #
    # @return [Array<Bundler::Dependency>]
    #
    # @since 0.1.0
    def select(*names)
      @dependencies
        .select { |dep| names.include?(dep.name) && (dep.groups & DEFAULT_GROUPS).any? }
    end

    # Check for rubygems exists
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.1.0
    def has?(*names)
      select(*names).any?
    end
  end
end
