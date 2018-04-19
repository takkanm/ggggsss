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
end
