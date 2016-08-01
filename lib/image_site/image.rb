require 'fileutils'
require_relative 'model'

module ImageSite
  class Image < Model
    def self.all(options)
      images = options.files.map.with_index(1) do |file, i|
        Image.new file: file, number: i, options: options
      end
      images.each.with_index do |image, i|
        if i > 0
          image.previous = images[i - 1]
        end
        if i < images.length - 1
          image.next = images[i + 1]
        end
      end
    end

    attr_accessor :next, :previous, :index

    def initialize(number:, file:, options:)
      super number, options
      @file = file
    end

    def write
      write_scaled_image unqualified_image, 912
      write_html
    end

    def unqualified_image
      "Images/#{@number}.jpeg"
    end

    def title
      xmp&.dc&.title&.first
    end

    NEWLINE = "\xE2\x80\xA8".force_encoding('ASCII-8BIT')

    def description
      exif.image_description&.gsub NEWLINE, "<br/>\n"
    end

    def tags
      xmp&.dc&.subject || []
    end

    def unqualified_page
      "Pages/#{@number}.html"
    end

    def write_thumbnail
      write_scaled_image unqualified_thumbnail, 240
    end

    def unqualified_thumbnail
      "Thumbnails/#{@number}.jpeg"
    end

    private

    def write_scaled_image(unqualified_name, size)
      make_subdir File.dirname(unqualified_name)
      ImageScience.with_image @file do |image|
        image.thumbnail size do |thumbnail|
          thumbnail.save "#{@options.output_dir}/#{unqualified_name}"
        end
      end
    end

    def self.page_template
      @page_template ||= IO.read 'etc/Page.html.erb'
    end

    def page_bindings
      { image: self }
    end

    def xmp
      @xmp ||= XMP.parse exif
    end

    def exif
      @exif ||= EXIFR::JPEG.new @file
    end

  end
end
