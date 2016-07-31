require 'fileutils'

module ImageSite
  class Image
    def initialize(file:, number:, index_number:, image_count:)
      @file = file
      @number = number
      @index_number = index_number
      @image_count = image_count
    end

    # TODO write image inside write_page, move thumbnail to index
    def write(output_dir)
      write_image output_dir
      write_page output_dir
      write_thumbnail output_dir
    end

    def title
      xmp.dc.title.first
    end

    def description
      exif.image_description&.gsub "\xE2\x80\xA8".force_encoding('ASCII-8BIT'), "<br/>\n"
    end

    def unqualified_page
      "Pages/#{@number}.html"
    end

    def unqualified_thumbnail
      "Thumbnails/#{@number}.jpeg"
    end

    private

    def write_image(output_dir)
      write_scaled_image output_dir, 'Images', 912
    end

    def write_page(output_dir)
      Image.make_subdir output_dir, 'Pages'
      bindings = {
        number: @number,
        index_number: @index_number,
        image_count: @image_count,
        title: title,
        description: description,
        tags: xmp.dc.subject
      }
      page = Erubis::Eruby.new(Image.page_template).result bindings
      IO.write "#{output_dir}/#{unqualified_page}", page
    end

    def xmp
      @xmp ||= XMP.parse exif
    end

    def exif
      @exif ||= EXIFR::JPEG.new @file
    end

    def self.page_template
      @page_template ||= IO.read 'etc/Page.html.erb'
    end

    def write_thumbnail(output_dir)
      write_scaled_image output_dir, 'Thumbnails', 240
    end

    def write_scaled_image(output_dir, subdir, size)
      Image.make_subdir output_dir, subdir
      ImageScience.with_image @file do |image|
        image.thumbnail size do |thumbnail|
          thumbnail.save "#{output_dir}/#{subdir}/#{@number}.jpeg" # TODO use unqualified methods
        end
      end
    end

    def self.make_subdir(output_dir, subdir)
      FileUtils.mkdir_p "#{output_dir}/#{subdir}"
    end

  end
end
