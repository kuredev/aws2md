require "json"
require "terminal-table"
require "active_support/all" # .singularize

module Aws2MD
  class Table
    def build_table
      raise NotImplementedError.new("NotImplementedError")
    end

    # @return [[header_keys], [more_keys]]
    #   header_keys: Keys whose values are scalars (e.g., String, Number, Boolean)
    #   more_keys: Keys whose values are nested structures (e.g., Array, Hash)
    def separate_keys(hash)
      header_keys = []
      more_keys = []

      hash.each do |k, v|
        if scalar?(v)
          header_keys << k
        else
          more_keys << k
        end
      end

      [header_keys, more_keys]
    end

    def scalar?(obj)
      return false if obj.is_a?(Hash)
      return false if obj.is_a?(Array)

      true
    end
  end

  class HorizontalTable < Table
    def initialize(json)
      @json = json
    end

    def print_table_for_hash(header_keys, rows)
      table = Terminal::Table.new :rows => [rows]
      table.headings = header_keys
      table.style = { :border => :markdown }
      puts ""
      puts table
    end

    def print_table_for_array(header_keys, rows, level, title, i)
      table = Terminal::Table.new :rows => [rows]
      table.headings = header_keys
      table.style = { :border => :markdown }

      heading = "#" * (level + 1)

      puts ""
      puts "#{heading} #{title.singularize}.#{i}"
      puts table
    end

    def build_table(title, current, level = 0)
      unless title.nil?
        puts ""
        heading = "#" * level
        puts "#{heading} #{title}"
      end

      if current.is_a?(Hash)
        # Keys with scalar values will be used as table columns
        # Other keys will be passed to build_table for recursive processing
        header_keys, more_keys = separate_keys(current)

        unless header_keys.empty?
          rows = []
          header_keys.each do |key|
            rows << current[key]
          end

          print_table_for_hash(header_keys, rows)
        end

        more_keys.each do |key|
          build_table(key, current[key], level + 1)
        end
      else current.is_a?(Array)
        current.each_with_index do |hash, i|
          header_keys, more_keys = separate_keys(hash)

          rows = []
          header_keys.each do |key|
            rows << hash[key]
          end

          print_table_for_array(header_keys, rows, level, title, i)

          more_keys.each do |key|
            build_table(key, hash[key], level + 2)
          end
        end
      end
    end

    def run
      build_table(nil, @json)
    end
  end

  class VerticalTable < Table
    def initialize(json)
      @json = json
    end

    def print_table_for_hash(rows)
      table = Terminal::Table.new :rows => rows
      table.headings = ["Key", "Value"]
      table.style = { :border => :markdown }
      puts ""
      puts table
    end

    def print_table_for_array(rows, title, level, i)
      table = Terminal::Table.new :rows => rows
      table.headings = ["Key", "Value"]
      table.style = { :border => :markdown }
      heading = "#" * (level + 1)

      puts ""
      puts "#{heading} #{title.singularize}.#{i}"
      puts table
    end

    def build_table(title, current, level = 0)
      unless title.nil?
        puts ""
        heading = "#" * level
        puts "#{heading} #{title}"
      end

      if current.is_a?(Hash)
        header_keys, more_keys = separate_keys(current)

        unless header_keys.empty?
          rows = header_to_rows(header_keys, current)
          print_table_for_hash(rows)
        end

        more_keys.each do |key|
          build_table(key, current[key], level + 1)
        end
      else current.is_a?(Array)
        current.each_with_index do |hash, i|
          header_keys, more_keys = separate_keys(hash)
          rows = header_to_rows(header_keys, hash)

          print_table_for_array(rows, title, level, i)

          more_keys.each do |key|
            build_table(key, hash[key], level + 2)
          end
        end
      end
    end

    def header_to_rows(header_keys, hash)
      header_keys.map { |key| [key, hash[key]] }
    end

    def run
      build_table(nil, @json)
    end
  end
end
