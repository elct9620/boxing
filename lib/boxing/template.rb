# frozen_string_literal: true

require 'erb'

module Boxing
  # Generate file from template
  #
  # @since 0.11.0
  class Template
    # @since 0.11.0
    TEMPLATE_DIR = File.expand_path('../../templates', __dir__)

    # @param [String] template
    # @param [Binding] context
    #
    # @since 0.11.0
    def initialize(template)
      @template = template
    end

    # Create template engine
    #
    # @return [ERB]
    #
    # @since 0.11.0
    # @api private
    def engine
      @engine ||= ERB.new(content, trim_mode: '-')
    end

    # Get template content
    #
    # @return [String]
    #
    # @since 0.11.0
    # @api private
    def content
      @content ||= File.read("#{TEMPLATE_DIR}/#{@template}")
    end

    # Render template
    #
    # @return [String]
    #
    # @since 0.11.0
    # @api private
    def render(context = nil)
      context = context.to_binding if context.respond_to?(:to_binding)
      engine.result(context)
    end
  end
end
