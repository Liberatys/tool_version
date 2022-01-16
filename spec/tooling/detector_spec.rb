module ToolVersion
  RSpec.describe Detector do
    let(:directory_table) {}

    let(:detector) do
      described_class.new(directory_interface, schemas: schemas)
    end

    let(:directory_interface) do
      TestToolingFileInterface.new(
        directory_table
      )
    end

    let(:schemas) { nil }

    describe "#fetch_tool_versions" do
      subject(:loaded_tool_versions) { detector.fetch_tool_versions }

      context "with github interface" do
        let(:client) do
          Octokit::Client.new
        end

        let(:repo) { "liberatys/nvim_conf" }

        let(:schemas) { :generic }

        let(:directory_interface) do
          ToolVersion::DirectoryInterfaces::Github.new(
            client,
            repo,
            branch: :master
          )
        end

        it "finds ruby version via :generic schema" do
          VCR.use_cassette("_detector_github_integration_ruby_detection") do
            expect(loaded_tool_versions).to contain_exactly(
              ToolVersion::Tool.new(
                "ruby",
                "3.0.2",
                ".tool-versions"
              )
            )
          end
        end
      end

      context "without any files" do
        it { is_expected.to eq([]) }
      end

      context "with files present" do
        let(:directory_table) do
          {
            ".tool-version" => "ruby 3.0.2\nnodejs 17.2.0"
          }
        end

        context "when no schema is given" do
          it "loads the version from .tool-version" do
            expect(loaded_tool_versions).to eq([
              ToolVersion::Tool.new(
                "ruby",
                "3.0.2",
                ".tool-version"
              ),
              ToolVersion::Tool.new(
                "nodejs",
                "17.2.0",
                ".tool-version"
              )
            ])
          end
        end

        context "when schema is :generic" do
          let(:schemas) { :generic }

          it "loads the version from .tool-version" do
            expect(loaded_tool_versions).to contain_exactly(
              ToolVersion::Tool.new(
                "ruby",
                "3.0.2",
                ".tool-version"
              ),
              ToolVersion::Tool.new(
                "nodejs",
                "17.2.0",
                ".tool-version"
              )
            )
          end
        end

        context "when schema is :ruby" do
          let(:schemas) { :ruby }

          let(:directory_table) do
            {
              ".ruby-version" => "2.7.3",
              "web/.ruby-version" => "2.7.1",
              "app/.ruby-version" => "2.6.3"
            }
          end

          it "loads the version from .ruby-version" do
            expect(loaded_tool_versions).to contain_exactly(
              ToolVersion::Tool.new(
                "ruby",
                "2.7.3",
                ".ruby-version"
              ),
              ToolVersion::Tool.new(
                "ruby",
                "2.7.1",
                "web/.ruby-version"
              ),
              ToolVersion::Tool.new(
                "ruby",
                "2.6.3",
                "app/.ruby-version"
              )
            )
          end
        end

        context "when schema is :nodejs" do
          let(:schemas) { :nodejs }

          let(:directory_table) do
            {
              ".ruby-version" => "2.7.3",
              "web/.ruby-version" => "2.7.1",
              "app/.ruby-version" => "2.6.3",
              ".nvmrc" => "v17.12.0",
              "tools/.nvmrc" => "v16.12.0"
            }
          end

          it "loads the version from .nvmrc" do
            expect(loaded_tool_versions).to contain_exactly(
              ToolVersion::Tool.new(
                "nodejs",
                "v17.12.0",
                ".nvmrc"
              ),
              ToolVersion::Tool.new(
                "nodejs",
                "v16.12.0",
                "tools/.nvmrc"
              )
            )
          end
        end

        context "when schema is mixed" do
          let(:schemas) { %i[ruby nodejs generic] }

          let(:directory_table) do
            {
              ".ruby-version" => "2.7.3",
              ".tool-version" => "ruby 3.0.2\nnodejs 17.2.0",
              "web/.ruby-version" => "2.7.1",
              "app/.ruby-version" => "2.6.3",
              ".nvmrc" => "v17.12.0",
              "tools/.nvmrc" => "v16.12.0"
            }
          end

          it "loads the version from .tool-version, .nvmrc, .ruby-version" do
            expect(loaded_tool_versions).to contain_exactly(
              ToolVersion::Tool.new(
                "nodejs",
                "v17.12.0",
                ".nvmrc"
              ),
              ToolVersion::Tool.new(
                "nodejs",
                "v16.12.0",
                "tools/.nvmrc"
              ),
              ToolVersion::Tool.new(
                "ruby",
                "2.7.3",
                ".ruby-version"
              ),
              ToolVersion::Tool.new(
                "ruby",
                "2.7.1",
                "web/.ruby-version"
              ),
              ToolVersion::Tool.new(
                "ruby",
                "3.0.2",
                ".tool-version"
              ),
              ToolVersion::Tool.new(
                "nodejs",
                "17.2.0",
                ".tool-version"
              ),
              ToolVersion::Tool.new(
                "ruby",
                "2.6.3",
                "app/.ruby-version"
              )
            )
          end
        end
      end
    end
  end
end
