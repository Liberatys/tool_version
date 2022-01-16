module ToolVersion
  module Detectors
    class Interface
      def initialize(directory_interface)
        @directory_interface = directory_interface
        @versions = []
      end

      private

      def add_version(name, version, path)
        @versions << ToolVersion::Tool.new(
          name, version, path
        )
      end
    end
  end
end
