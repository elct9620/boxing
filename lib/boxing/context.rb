# frozen_string_literal: true

module Boxing
  # The template context
  #
  # @since 0.1.0
  class Context
    # @param database [Boxing::Database]
    # @param dependencies [Array<Bundler::Dependency>]
    #
    # @since 0.1.0
    def initialize(database, dependencies = [])
      @database = database
      @dependencies = dependencies
    end

    # Return required packages
    #
    # @return [Set<Boxing::Package>] packages
    #
    # @since 0.1.0
    def packages
      @packages ||=
        Set
        .new(default_packages)
        .merge(
          @dependencies
          .map(&:name)
          .flat_map { |name| @database.package_for(name).to_a }
        )
    end

    # Check rubygems exists
    #
    # @param names [Array<String>]
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.1.0
    def has?(*names)
      @dependencies.any? { |dep| names.include?(dep.name) }
    end

    # Does any gem from git
    #
    # @return [TrueClass|FalseClass]
    #
    # @since 0.4.0
    def git?
      @dependencies.any?(&:git)
    end

    # Default packages
    #
    # @return [Array<Boxing::Package>]
    #
    # @since 0.4.0
    def default_packages
      [
        Package.new('build-base', mode: Package::BUILD)
      ]
        .push(git? ? Package.new('git', mode: Package::BUILD) : nil)
        .compact
    end

    # Convert to binding
    #
    # @return [Binding]
    #
    # @since 0.1.0
    def to_binding
      binding
    end
  end
end
