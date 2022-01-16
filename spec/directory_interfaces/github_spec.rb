module ToolVersion
  module DirectoryInterfaces
    RSpec.describe Github do
      describe ".new" do
        subject(:instance) { described_class.new(client, repo, branch: :master) }

        let(:client) do
          Octokit::Client.new
        end

        let(:repo) { "liberatys/nvim_conf" }

        it "loads all files for repoistory" do
          VCR.use_cassette("_providers_github_directory_interface_nvim_master") do
            expect(instance.files.length).not_to eq(0)
          end
        end

        it "can fetch file content from github" do
          VCR.use_cassette("_providers_github_directory_interface_nvim_master_with_file_content_donwload") do
            expect(instance.files.length).not_to eq(0)
            expect(instance.content("Gemfile")).to include("gemspec")
          end
        end

        it "can fetch all files and then allow pattern search" do
          VCR.use_cassette("_providers_github_directory_interface_nvim_master_with_pattern_search") do
            expect(instance.files.length).not_to eq(0)
            expect(
              instance.find(/Gemfile*/)
            ).to eq(["Gemfile", "Gemfile.lock"])
          end
        end
      end
    end
  end
end
