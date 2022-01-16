module ToolVersion
  module Detectors
    class Asdf < ToolVersion::Detectors::Interface
      MAIN_FILE_PATTERN = /.tool-version/

      def versions
        relevant_files.each do |file_path, file_content|
          parse_file_content(file_content).each do |extracted_version|
            add_version(
              extracted_version[:name],
              extracted_version[:version],
              file_path
            )
          end
        end

        @versions
      end

      private

      def relevant_files
        @directory_interface.find(MAIN_FILE_PATTERN).to_h do |file_path|
          [
            file_path,
            @directory_interface.content(file_path)
          ]
        end
      end

      def parse_file_content(content)
        return [] if content.nil?
        return [] if content.length.zero?

        local_versions = []

        content.split("\n").each do |source_line|
          tool_name, version = source_line.strip.split(" ")
          local_versions << {name: tool_name, version: version}
        end

        local_versions
      end
    end
  end
end
