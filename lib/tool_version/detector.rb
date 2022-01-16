module ToolVersion
  class Detector
    TOOL_DETECTOR = {
      generic: ToolVersion::Detectors::Asdf,
      ruby: ToolVersion::Detectors::Ruby,
      nodejs: ToolVersion::Detectors::Node
    }

    def initialize(directory_interface, schemas: :generic)
      @directory_interface = directory_interface
      @schemas = Array(schemas || :generic)
    end

    # Run through the specified schema and fetch the most recent version for tooling
    def fetch_tool_versions
      @schemas.map do |schema|
        Array(TOOL_DETECTOR[schema.to_sym]).map do |tool_detector|
          detector_instance = tool_detector.new(
            @directory_interface
          )
          detector_instance.versions
        end
      end.flatten
    end
  end
end
