require 'fileutils'
require 'image_science'
require 'xmp'
require 'exifr/jpeg'
require_relative 'model'

module ImageSite
  class Image < Model
    def self.all(options)
      images = options.files.map.with_index(1) do |file, i|
        Image.new i, file, options
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

    def self.template_name
      'Page.html.erb'
    end
    private_class_method :template_name

    attr_accessor :next, :previous, :index

    def initialize(number, file, options)
      super number, options
      @file = file
    end

    def write
      write_scaled_image relative_image, 912
      write_html image: self
    end

    def relative_image
      "Images/#{@number}.jpeg"
    end

    def title
      title = dc(:title)
      title && title.first || nil # title can be false, so we can't use &.
    end

    NEWLINE = "\xE2\x80\xA8".force_encoding('ASCII-8BIT')

    def description
      exif.image_description && exif.image_description.gsub(NEWLINE, "<br/>\n").force_encoding('utf-8')
    end

    def tags
      dc(:subject) || []
    end

    def relative_html
      "Pages/#{@number}.html"
    end

    def write_thumbnail
      write_scaled_image relative_thumbnail, 240
    end

    def relative_thumbnail
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

    def dc(property)
      xmp && xmp.respond_to?(:dc) && xmp.dc && xmp.dc.respond_to?(property) && xmp.dc.send(property)
    end

    def xmp
      @xmp ||= XMP.parse exif
    end

    def exif
      @exif ||= EXIFR::JPEG.new @file
    end

  end
end
