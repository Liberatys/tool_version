module ToolVersion
  module DirectoryInterfaces
    class Github
      DEFAULT_RELEVANT_BRANCH = :main
      attr_reader :files

      def initialize(client, repository, branch: DEFAULT_RELEVANT_BRANCH)
        @client = client
        @repository = repository
        @files = load_all_files(client, repository, branch)
      end

      def find(pattern)
        @files.select do |file_path|
          file_path.match(pattern)
        end
      end

      def content(file_path)
        response = @client.contents(@repository, path: file_path)
        Base64.decode64(response[:content])
      end

      private

      def load_all_files(client, repository, branch)
        options = [
          "recursive=1"
        ].join("&")

        extract_files_from_response(
          client.get("/#{main_list_query(repository, branch)}?#{options}")
        )
      end

      def main_list_query(repository, branch)
        [
          "repos",
          repository,
          "git",
          "trees",
          branch
        ].join("/")
      end

      def extract_files_from_response(response)
        response[:tree].map(&:path)
      end
    end
  end
end
