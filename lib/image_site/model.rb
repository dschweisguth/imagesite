module ImageSite
  class Model
    attr_reader :number

    def self.template
      @template ||= IO.read "template/#{template_name}"
    end

    def initialize(number, options)
      @number = number
      @options = options
    end

    def make_subdir(subdir)
      FileUtils.mkdir_p "#{@options.output_dir}/#{subdir}"
    end

    def write_html(bindings)
      make_subdir File.dirname(relative_html)
      bindings = { options: @options }.merge bindings
      page = Erubis::Eruby.new(self.class.template).result(bindings)
      IO.write "#{@options.output_dir}/#{relative_html}", page
    end

  end
end
