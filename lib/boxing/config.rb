# frozen_string_literal: true

module Boxing
  # The config of boxing
  #
  # @since 0.5.0
  class Config
    # @!attribute root
    #   @return [String] the application root
    #
    # @since 0.5.0
    attr_accessor :root

    # @since 0.5.0
    def initialize(&block)
      @root = '/srv/app'

      instance_exec(self, &block) if defined?(yield)
    end
  end
end
