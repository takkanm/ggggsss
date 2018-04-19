require 'optparse'
require "ggggsss/version"

require 'aws-sdk-s3'

module Ggggsss
  class Command
    attr_reader :bucket_name, :keyword, :path

    def initialize(args)
      @bucket_name = ''
      opt_parser = OptionParser.new
      opt_parser.on('-b BUCKET_NAME', '--bucket-name BUCKET_NAME') {|name| @bucket_name = name }
      opt_parser.banner += ' KEYWORD PATH_PREFIX'

      opt_parser.parse!(args)

      @keyword, @path = *args
    end

    def execute!
      fetcher = S3Fetcher.new(@bucket_name, @path)
      fetcher.fetch!

      fetcher.objects.each do |s3_object|
        collector = LineCollector.new(s3_object.body, @keyword)
        collector.collect!

        printer = ResultPrinter.new(s3_object.key, collector.results)
        printer.print
      rescue => e
        puts "#{s3_object.key}: #{e.message}"
      end
    end
  end

  class S3Object
    attr_reader :key, :body

    def initialize(key:, body:)
      @key = key
      @body = body
    end
  end

  class S3Fetcher
    attr_reader :objects

    def initialize(bucket_name, path)
      @bucket_name = bucket_name
      @path = path
      @objects = []
    end

    def fetch!
      s3 = Aws::S3::Resource.new
      bucket = s3.bucket(@bucket_name)
      bucket.objects(prefix: @path).each do |object_summary|
        object_output = object_summary.get
        @objects << S3Object.new(key: object_summary.key, body: object_output.body)
      end
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

  class ResultPrinter
    def initialize(filename, results)
      @filename = filename
      @results = results
    end

    def print
      @results.each do |result|
        puts "#{@filename}:#{result.line_no}:#{result.line}"
      end
    end
  end
end
