require 'optparse'
require_relative 'index'

module ImageSite
  class ImageSite
    def run
      parse_options!
      the_images = images
      the_images.each { |image| image.write @options[:output_dir] }
      indexes(the_images).each { |index| index.write @options[:output_dir] }
    end

    private

    def parse_options!
      @options = { columns: 4, rows: 10 }
      parser = OptionParser.new do |op|
        op.banner = "Usage: #{$0} -t TITLE -o OUTPUT_DIR [other options] file [...]"

        op.on('-t TITLE', "Title of the set of images") do |title|
          @options[:title] = title
        end
        op.on('-c COLUMNS', "The number of columns of thumbnails on each index page") do |columns|
          @options[:columns] = columns.to_i
        end
        op.on('-r ROWS', "The number of rows of photos on each index page") do |rows|
          @options[:rows] = rows.to_i
        end
        op.on('-o OUTPUT_DIR', "Output directory") do |output_dir|
          @options[:output_dir] = output_dir
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
      if !@options[:title]
        abort_with_help parser, "Please specify a title with -t."
      end
      if !@options[:output_dir]
        abort_with_help parser, "Please specify an output directory with -o."
      end
      if ARGV.empty?
        abort_with_help parser, "Please specify one or more image files."
      end
      @options[:files] = ARGV
    end

    def abort_with_help(parser, message)
      abort "#{message}\n#{parser}"
    end

    def images
      images_per_page = @options[:rows] * @options[:columns]
      @options[:files].map.with_index do |file, i|
        Image.new file: file, number: i + 1,
          index_number: i / images_per_page + 1,
          image_count: @options[:files].length
      end
    end

    def indexes(images)
      images.
      each_slice(@options[:columns] * @options[:rows]).
      with_index.
      map do |images_for_index, i|
        Index.new(
          number: i + 1,
          images: images_for_index,
          total_image_count: images.length,
          rows: @options[:rows],
          columns: @options[:columns],
          title: @options[:title]
        )
      end
    end

    # TODO extract images_per_page

  end
end
