# frozen_string_literal: true

module Boxing
  # The template context
  #
  # @since 0.1.0
  class Context
    # @since 0.5.0
    attr_reader :config

    # @param config [Boxing::Config]
    # @param database [Boxing::Database]
    # @param dependencies [Array<Bundler::Dependency>]
    #
    # @since 0.1.0
    def initialize(config, database, dependencies = [])
      @config = config
      @database = database
      @dependencies = dependencies

      @config.port = 3000 if has?('rails')
    end

    # Return required packages
    #
    # @return [Set<Boxing::Package>] packages
    #
    # @since 0.1.0
    def packages
      @packages ||=
        Set
        .new(default_packages + extra_packages)
        .merge(
          @dependencies
          .map(&:name)
          .flat_map { |name| @database.package_for(name).to_a }
        )
    end

    # Exclude Gems in container images
    #
    # @return [Array<String>]
    #
    # @since 0.11.0
    def exclude_groups
      @exclude_groups ||= config.exclude_groups || []
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
        .push(has?('liveness') ? Package.new('curl', mode: Package::RUNTIME) : nil)
        .compact
    end

    # Extra Packages
    #
    # @return [Array<Boxing::Package>]
    #
    # @since 0.6.0
    def extra_packages
      [config.build_packages, config.runtime_packages].flatten.map do |name|
        next if name.nil?

        Package.new(name, mode: mode_of(name))
      end.compact
    end

    # Return node.js version
    #
    # @return [String]
    #
    # @since 0.6.0
    def node_version
      return config.node_version if config.node_version

      `node -v`.gsub(/^v/, '')
    end

    # Convert to binding
    #
    # @return [Binding]
    #
    # @since 0.1.0
    def to_binding
      binding
    end

    # Check Package Mode
    #
    # @return [Number]
    #
    # @since 0.6.3
    def mode_of(name)
      mode = 0
      mode |= Package::BUILD if config.build_packages&.include?(name)
      mode |= Package::RUNTIME if config.runtime_packages&.include?(name)
      mode
    end

    # Return entrypoint options
    #
    # @return [Array<String>]
    #
    # @since 0.9.0
    def entrypoint
      return config.entrypoint.map(&:to_s) if config.entrypoint
      return ['bin/aws_lambda_ric'] if has?('aws_lambda_ric')
      return ['bin/openbox'] if has?('openbox')
      return ['bin/rails'] if has?('rails')

      %w[bundle exec]
    end

    # Return command options
    #
    # @return [Array<String>]
    #
    # @since 0.9.0
    def command
      return config.command.map(&:to_s) if config.command
      return ['config/environment.Lamby.cmd'] if has?('lamby')
      return ['config/environment.Aws::Rails::SqsActiveJob.lambda_job_handler'] if has?('aws-sdk-rails')
      return ['server'] if has?('openbox')
      return ['server', '-b', '0.0.0.0'] if has?('rails')

      ['rackup', '-o', '0.0.0.0']
    end
  end
end
