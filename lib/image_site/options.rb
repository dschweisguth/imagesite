require 'optparse'

module ImageSite
  class Options
    DEFAULT_COLUMNS = 4
    DEFAULT_ROWS = 10

    attr_reader :title, :columns, :rows, :descriptions_on_index_pages, :parent_link_text, :output_dir, :files

    def initialize
      @title = nil
      @columns = DEFAULT_COLUMNS
      @rows = DEFAULT_ROWS
      @descriptions_on_index_pages = false
      @parent_link_text = nil
      @output_dir = nil
    end

    def parse!
      parser = OptionParser.new do |op|
        op.banner = "Usage: #{$PROGRAM_NAME} -t TITLE -o OUTPUT_DIR [other options] file [...]"

        op.on('-t TITLE', "Title of the set of images") do |title|
          @title = title
        end
        op.on('-c COLUMNS', "The number of columns of thumbnails on each index page (default #{DEFAULT_COLUMNS})") do |columns|
          @columns = columns.to_i
        end
        op.on('-r ROWS', "The number of rows of photos on each index page (default #{DEFAULT_ROWS})") do |rows|
          @rows = rows.to_i
        end
        op.on('-d', "Descriptions are included on index pages") do
          @descriptions_on_index_pages = true
        end
        op.on('-p PARENT_LINK_TEXT', "The text of the link to ../ on the last index page") do |parent_link_text|
          @parent_link_text = parent_link_text
        end
        op.on('-o OUTPUT_DIR', "Output directory") do |output_dir|
          @output_dir = output_dir
        end

        # -h and --help work by default, but implement them explicitly so they're
        # documented
        op.on("-h", "--help", "Prints this help") do
          warn op.to_s
          exit
        end

      end
      begin
        parser.parse!
      rescue OptionParser::ParseError
        abort parser.to_s
      end
      if !@title
        abort_with_help parser, "Please specify a title with -t."
      end
      if !@output_dir
        abort_with_help parser, "Please specify an output directory with -o."
      end
      if ARGV.empty?
        abort_with_help parser, "Please specify one or more image files."
      end
      @files = ARGV
    end

    def abort_with_help(parser, message)
      abort "#{message}\n#{parser}"
    end

  end
end
