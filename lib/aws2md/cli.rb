require "json"
require "optparse"
require "aws2md/table" # ← テーブルロジック本体を別ファイルにする場合

module Aws2MD
  class CLI
    def run
      options = {}

      OptionParser.new do |opts|
        opts.banner = "Usage: aws2md [options]"

        opts.on("-o", "--output FORMAT", "Output format (v/h)") do |v|
          unless %w[v h].include?(v)
            raise OptionParser::InvalidArgument, "Invalid output format: #{v}. Must be 'v' or 'h'."
          end
          options[:output] = v
        end

        opts.on("-h", "--help", "Show help") do
          puts opts
          exit
        end
      end.parse!

      begin
        if STDIN.tty?
          warn "Error: No input detected. Please pipe JSON data into this command."
          exit 1
        end

        input = STDIN.read

        if input.strip.empty?
          warn "Error: Input is empty. Please provide valid JSON via pipe."
          exit 1
        end

        json = JSON.parse(input)
      rescue JSON::ParserError => e
        warn "Error: Invalid JSON input - #{e.message}"
        exit 1
      end

      md = case options[:output]
           when "v"
             Aws2MD::VerticalTable.new(json)
           when "h"
             Aws2MD::HorizontalTable.new(json)
           else
             Aws2MD::HorizontalTable.new(json)
           end

      md.run
    end
  end
end
