require_relative 'image'

module ImageSite
  class Index < Model
    def self.write_all(options)
      images = Image.all options
      indexes = all images, options
      images.each(&:write)
      indexes.each(&:write)
    end

    def self.all(images, options)
      indexes =
        images.
        each_slice(options.columns * options.rows).
        with_index(1).
        map do |images_for_index, i|
          Index.new(
            number: i,
            images: images_for_index,
            options: options
          )
        end
      indexes.each do |index|
        index.indexes = indexes
        index.images.each { |image| image.index = index }
      end
    end
    private_class_method :all

    attr_reader :images
    attr_accessor :indexes

    def initialize(number:, images:, options:)
      super number, options
      @images = images
    end

    def write
      images.each(&:write_thumbnail)
      write_html
    end

    def unqualified_page
      "index#{if @number > 1 then @number end}.html"
    end

    private

    def self.page_template
      @page_template ||= IO.read 'etc/index.html.erb'
    end

    def page_bindings
      { index: self }
    end

  end
end
