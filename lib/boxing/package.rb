# frozen_string_literal: true

module Boxing
  # The rubygems mapping for Linux package
  #
  # @since 0.1.0
  class Package
    # @since 0.1.0
    attr_reader :name, :version

    # @param name [String] the package name
    # @param version [String] the package version
    #
    # @since 0.1.0
    def initialize(name, version = nil)
      @name = name
      @version = version
    end

    # Convert to string
    #
    # @return [String] the package string
    #
    # @since 0.1.0
    def to_s
      return @name if @version.nil?

      # NOTE: Alpine format only
      "#{@name}=#{@version}"
    end
  end
end
