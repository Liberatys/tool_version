# frozen_string_literal: true

RSpec.describe ToolVersion do
  it "has a version number" do
    expect(ToolVersion::VERSION).not_to be nil
  end

  describe ".detect_tools" do
    let(:client) do
      Octokit::Client.new
    end

    let(:repo) { "liberatys/nvim_conf" }

    it "loads versions for given repository" do
      VCR.use_cassette("_tool_version_integration_detect_tools") do
        expect(
          ToolVersion.detect_tools(client, repo, :ruby, branch: :master)
        ).to contain_exactly(
          ToolVersion::Tool.new(
            "ruby",
            "3.0.2",
            ".ruby-version"
          )
        )
      end
    end
  end
end
