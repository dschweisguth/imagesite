require_relative 'options'
require_relative 'index'

module ImageSite
  class ImageSite
    def run
      options = Options.new
      options.parse!
      Index.write_all(options)
    end
  end
end
