require "pathname"

module ToolVersion
  class Tool
    include Comparable

    attr_reader :name, :version, :path, :directory

    def initialize(name, version, path)
      @name = name
      @version = version
      @path = path
      @directory = extract_directory(path)
    end

    def <=>(other)
      (name <=> other.name) && (version <=> other.version) && (directory <=> other.directory) && (path <=> other.path)
    end

    private

    def extract_directory(path)
      Pathname.new(path).dirname.to_s
    end
  end
end
