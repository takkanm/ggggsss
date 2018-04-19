require 'optparse'
require "ggggsss/version"

module Ggggsss
  class Command
    attr_reader :bucket_name, :keyword, :path

    def initialize(args)
      @bucket_name = ''
      opt_parser = OptionParser.new
      opt_parser.on('-b BUCKET_NAME', '--bucket-name BUCKET_NAME') {|name| @bucket_name = name }

      opt_parser.parse!(args)

      @keyword, @path = *args
    end
  end

  class ResultLine
    attr_reader :line_no, :line

    def initialize(line_no:, line:)
      @line_no = line_no
      @line = line
    end

    def ==(others)
      line_no == others.line_no && line == others.line
    end
  end

  class LineCollector
    attr_reader :results

    def initialize(io, keyword)
      @io = io
      @keyword = Regexp.new(keyword)
      @results = []
    end

    def collect!
      @io.read.each_line.with_index(1) do |line, line_no|
        @results << ResultLine.new(line_no: line_no, line: line.chomp) if @keyword.match?(line)
      end
    end
  end
end
