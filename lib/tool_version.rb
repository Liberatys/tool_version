# frozen_string_literal: true

require_relative "tool_version/detectors/interface"
require_relative "tool_version/detectors/ruby"
require_relative "tool_version/detectors/node"
require_relative "tool_version/detectors/asdf"
require_relative "tool_version/version"
require_relative "tool_version/detector"
require_relative "tool_version/tool"
require_relative "tool_version/directory_interfaces/github"

module ToolVersion
  class Error < StandardError; end

  PROVIDER_INTERFACES = {
    github: ToolVersion::DirectoryInterfaces::Github
  }

  def self.detect_tools(client, repository, schemas, branch: :main, provider: :github)
    directory_interface = PROVIDER_INTERFACES[provider].new(
      client,
      repository,
      branch: branch
    )

    ToolVersion::Detector.new(
      directory_interface,
      schemas: schemas
    ).fetch_tool_versions
  end
end
