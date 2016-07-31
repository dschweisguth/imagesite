require_relative 'image'

module ImageSite
  class Index
    def initialize(number:, images:, total_image_count:, columns:, rows:, title:)
      @number = number
      @images = images
      @total_image_count = total_image_count
      @columns = columns
      @rows = rows
      @title = title
    end

    def write(output_dir)
      bindings = {
        title: @title,
        index_count: (@total_image_count + (@columns * @rows) - 1) / (@columns * @rows),
        images: @images,
        columns: @columns,
        number: @number
      }
      page = Erubis::Eruby.new(Index.page_template).result bindings
      IO.write "#{output_dir}/index#{if @number > 1 then @number end}.html", page
    end

    private

    def self.page_template
      @page_template ||= IO.read 'etc/index.html.erb'
    end

  end
end
