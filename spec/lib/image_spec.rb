describe ImageSite::Image do
  describe '#write' do
    let(:output_dir) { '/tmp/imagesite-test-output' }
    before { FileUtils.rm_rf output_dir }

    # This is already adequately tested by the acceptance spec, but we need a
    # baseline for the no-metadata example
    it "handles an image with all metadata" do
      image = create_image('spec/data/test-all-metadata.jpeg')
      image.write
      page = parsed_page image
      h1s = page.css('h1')
      expect(h1s.length).to eq(1)
      expect(h1s.first.text).to eq('Image title')
      expect(page.css('p').count { |p| p.text == 'Image description' }).to eq(1)
      expect(page.css('b').map(&:text)).to eq(['Image tag 1', 'Image tag 2'])
    end

    it "handles an image with no metadata" do
      image = create_image('spec/data/test-no-metadata.jpeg')
      image.write
      page = parsed_page image
      expect(page.css('h1')).to be_empty
      expect(page.css('p').any? { |p| p.children.empty? && p.text.empty? }).to be false # i.e. there is no empty description or tags
    end

    it "handles an image with no subject" do
      expect { create_image('spec/data/test-no-subject.jpeg').write }.to_not raise_error
    end

    it "handles an image with no title" do
      expect { create_image('spec/data/test-no-title.jpeg').write }.to_not raise_error
    end

    def create_image(file)
      stub_const 'ARGV', ['-t', 'Title', '-o', output_dir, file]
      options = ImageSite::Options.new
      options.parse!
      image = ImageSite::Image.new 1, file, options
      index = ImageSite::Index.new 1, [image], options
      image.index = index
      image
    end

    def parsed_page(image)
      File.open("#{output_dir}/#{image.relative_html}") { |file| Nokogiri::XML(file) }
    end

  end
end
