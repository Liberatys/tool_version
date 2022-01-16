class TestToolingFileInterface
  def initialize(file_table)
    @file_table = file_table || {}
  end

  def find(pattern)
    @file_table.keys.select do |file_path|
      file_path.match(pattern)
    end
  end

  def content(path)
    @file_table[path]
  end
end
