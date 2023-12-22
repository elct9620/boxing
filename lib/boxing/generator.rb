# frozen_string_literal: true

module Boxing
  # Generate file from template
  #
  # @since 0.11.0
  class Generator
    include Utils

    # Generate file
    #
    # @since 0.11.0
    def execute(destination, template, context: nil)
      destination = current_path.join(destination)
      write(destination, template.render(context))
    end

    # Write file to relative path
    #
    # @param [String] destination
    # @param [String] content
    def write(destination, content)
      FileUtils.mkdir_p(File.dirname(destination))
      File.write(destination, content)
    end
  end
end
