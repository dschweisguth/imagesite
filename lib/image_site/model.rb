module ImageSite
  class Model
    attr_reader :number

    def initialize(number, options)
      @number = number
      @options = options
    end

    def make_subdir(subdir)
      FileUtils.mkdir_p "#{@options.output_dir}/#{subdir}"
    end

    def write_html
      make_subdir File.dirname(unqualified_page)
      bindings = { options: @options }.merge page_bindings
      page = Erubis::Eruby.new(self.class.page_template).result(bindings)
      IO.write "#{@options.output_dir}/#{unqualified_page}", page
    end

  end
end
